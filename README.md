# Backup and Restore Scripts

This project contains two Bash scripts for automating the backup and restoration of directories. The `backup.sh` script creates backups of a specified directory at regular intervals, and the `restore.sh` script allows you to restore a directory from those backups.

## Requirements

- Bash
- A Unix-based operating system (Linux, macOS, etc.)

## Files

- `backup.sh`: Script for creating periodic backups.
- `restore.sh`: Script for restoring the latest or previous backups.
- `Makefile`: Provides simple commands for running the backup and restore scripts.

## Usage

### Backup Script

This script takes four arguments:
1. `BACKUP_FROM`: The source directory to back up.
2. `BACKUP_TO`: The destination directory where backups are stored.
3. `FREQUENCY`: Time interval (in seconds) between consecutive backups.
4. `NUM_OF_BACKUPS`: Maximum number of backups to keep. Older backups will be deleted once this limit is exceeded.

**Example Usage:**

```bash
bash backup.sh /path/to/source /path/to/backup 60 5
```

This will back up the contents of `/path/to/source` every 60 seconds, keeping a maximum of 5 backups in `/path/to/backup`.

### Restore Script

This script takes two arguments:
1. `SOURCE_DIR`: The directory to restore the backup to.
2. `BACKUP_DIR`: The directory where backups are stored.

**Example Usage:**

```bash
bash restore.sh /path/to/source /path/to/backup
```

This will restore the latest backup from `/path/to/backup` to `/path/to/source`.

Once the restore starts, you'll be prompted with options to:
1. Restore to an older version.
2. Move forward to the next backup version.
3. Exit.

### Makefile

To simplify the running of the scripts, a `Makefile` is included with the following targets:

- `run_backup`: Runs the `backup.sh` script.
- `run_restore`: Runs the `restore.sh` script.
- `create_backup_dir`: Creates the backup directory if it doesn't exist.

**Example Usage:**

To run the backup process using the `Makefile`, first customize the variables in the Makefile:

```makefile
BACKUP_FROM=../"to be backuped"
BACKUP_TO=../backup
FREQUENCY=10
MAX=3
```

Then execute the following commands:

```bash
make run_backup
```

To run the restore process:

```bash
make run_restore
```

The `create_backup_dir` target will ensure the backup directory exists before running the backup or restore scripts.

## Notes

- The backup script will keep checking for changes in the source directory and create new backups when changes are detected.
- The restore script allows you to restore the most recent or older backups.
- Ensure that the `BACKUP_FROM` and `BACKUP_TO` directories are properly set in your environment.
```

This `README.md` explains how to use the backup and restore scripts and the associated Makefile for easier execution.
