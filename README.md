# About

This is the script I use for backing up my servers.
The script depends on [BorgBackup](https://www.borgbackup.org/), and offers hooks for running programs before and after the backup.
Be aware that it will conditionally prune existing backups.
When an error occurs, the script will send a notification to the specified [Gotify](https://gotify.net/) application.

# Usage

Have a look at the `config.sample` file.
It already contains all the keys you need to configure.
Also, you will need to put the BorgBackup phrase in the file `borg.phrase` inside this directory.
To run the script regularly, I recommend setting up a [systemd](https://freedesktop.org/wiki/Software/systemd/) timer.
