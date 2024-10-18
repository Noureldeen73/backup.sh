BACKUP_FROM=.
BACKUP_TO=../backup
FREQUENCY=10
MAX=3

run_backup: create_backup_dir
	@echo "Running backup script..."
	@bash backupd.sh $(BACKUP_FROM) $(BACKUP_TO) $(FREQUENCY) $(MAX)

run_restore: create_backup_dir
	@echo "Running restore script..."
	@bash restore.sh $(BACKUP_FROM) $(BACKUP_TO)	

create_backup_dir:
	@if [ ! -d "$(BACKUP_TO)" ]; then \
		echo "Creating backup directory: $(BACKUP_TO)"; \
		mkdir -p "$(BACKUP_TO)"; \
		echo "Backup directory created : $(BACKUP_TO)"; \
	else \
		echo "Backup directory already exists: $(BACKUP_TO)"; \
	fi

.PHONY: run_backup run_restore



