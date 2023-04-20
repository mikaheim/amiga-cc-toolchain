all:
	@for d in $$(ls -d *); do \
		if [ -d $$d ]; then \
			echo "Building examples in folder $$d"; \
			$(MAKE) -C $$d all; \
		fi; \
	done;

clean:
	@for d in $$(ls -d *); do \
		if [ -d $$d ]; then \
			echo "Cleaning examples in folder $$d"; \
			$(MAKE) -C $$d clean; \
		fi; \
	done;
