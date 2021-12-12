## About

This is the script I use for backing up my servers.
The script depends on [restic](https://restic.net/).
Be aware that it will conditionally prune existing backups.
When an error occurs, the script will send a notification to the specified [PushBits](https://www.pushbits.io/) application.

## Usage

Have a look at `example/`.
Copy the example files to the XDG config directory (e.g., `~/.config/bavice`) and adapt their contents.

To run the script, I recommend using [systemd](https://freedesktop.org/wiki/Software/systemd/).
See `bavice.service` and `bavice.timer` for templates to setup a service and a timer respectively.
