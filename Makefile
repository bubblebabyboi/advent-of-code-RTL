.PHONY: default all clean clean-all help

DAY ?= 1

default:
	@if [ -d "day_$(DAY)" ]; then \
		echo "Day $(DAY):"; \
		$(MAKE) -C day_$(DAY) run; \
	else \
		echo "Error: day_$(DAY) not found"; \
		exit 1; \
	fi

all:
	@for dir in day_*; do \
		if [ -d "$$dir" ]; then \
			echo "Running $$dir..."; \
			$(MAKE) -C $$dir run || exit 1; \
		fi \
	done

clean:
	@if [ -d "day_$(DAY)" ]; then \
		echo "Cleaning day_$(DAY)..."; \
		$(MAKE) -C day_$(DAY) clean; \
	fi

clean-all:
	@for dir in day_*; do \
		if [ -d "$$dir" ]; then \
			echo "Cleaning $$dir..."; \
			$(MAKE) -C $$dir clean; \
		fi \
	done

help:
	@echo "Advent of Code 2025 - RTL"
	@echo ""
	@echo "Usage:"
	@echo "  make            - Run day 1 (default)"
	@echo "  make DAY=N      - Run day N"
	@echo "  make all        - Run all days"
	@echo "  make clean      - Clean day 1 (default)"
	@echo "  make clean DAY=N - Clean day N"
	@echo "  make clean-all  - Clean all days"
	@echo ""
