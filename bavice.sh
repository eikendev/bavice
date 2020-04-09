#!/usr/bin/env bash

set -eE

exec 1> >(logger -t "$SCRIPT_NAME") 2>&1

BACKUP_DIRECTORIES='
	/etc
'

SCRIPT_NAME='bavice'
SCRIPT_PATH="$(dirname "${BASH_SOURCE[0]}")"
FILE_LOCK='/tmp/'$SCRIPT_NAME'.lock'
FILE_PHRASE="$SCRIPT_PATH/borg.phrase"

# Dummy functions. Can be redefined by the configuration.
function pre_unlock() { :; }
function pre_backup() { :; }

source "$SCRIPT_PATH/local.sh"

export BORG_REPO="ssh://$BORG_USER@$BORG_HOST:$BORG_PORT/$BORG_PATH"
export BORG_PASSPHRASE=$(head -n 1 $FILE_PHRASE)

if [ -z "$GOTIFY_BASEURL" ]; then
	printf "%s\n" 'No base URL for Gotify was supplied!'
	exit 1
fi

if [ -z "$GOTIFY_APPTOKEN" ]; then
	printf "%s\n" 'No application token for Gotify was supplied!'
	exit 1
fi

function unlock() {
	pre_unlock

	rm -f "$FILE_LOCK"
}

function cleanup() {
	unlock
}

function error_exit() {
	cleanup

	curl "$GOTIFY_BASEURL/message?token=$GOTIFY_APPTOKEN" \
		-F 'title=Error during backup service routine' \
		-F 'message=An error occured during backing up a device with Bavice.' \
		-F 'priority=5'
}

trap error_exit ERR

function lock() {
	if [ ! -e "$FILE_LOCK" ]; then
		touch "$FILE_LOCK"
	else
		printf "%s\n" 'Backup is already running.'
		exit 1
	fi
}

function create_backup() {
	borg create                         \
		--verbose                       \
		--filter AME                    \
		--list                          \
		--stats                         \
		--show-rc                       \
		--compression zstd,16           \
		--exclude-caches                \
		::'{hostname}-{now}'            \
		$BACKUP_DIRECTORIES             \
	;
}

function prune_repository() {
	borg prune                          \
		--list                          \
		--prefix '{hostname}-'          \
		--show-rc                       \
		--keep-daily    7               \
		--keep-weekly   4               \
		--keep-monthly  6               \
		--keep-yearly   1               \
	;
}

printf "%s\n" 'Setting up the lock.'
lock

printf "%s\n" 'Running pre-backup hook.'
pre_backup

printf "%s\n" 'Creating backup.'
create_backup

printf "%s\n" 'Pruning repository.'
prune_repository

printf "%s\n" 'Cleaning up.'
cleanup

$SCRIPT_PATH/timestamp.sh

printf "%s\n" 'Backup Service Routine successful.'
