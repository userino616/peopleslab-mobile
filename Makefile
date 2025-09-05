.PHONY: dump-lib

# Generate dump.txt with all files under lib/ (filename + contents)
dump-lib:
	@echo "Generating dump.txt from lib/ ..."
	@: > dump.txt
	@LC_ALL=C find lib -type f | sort | while read -r f; do \
		printf "===== %s =====\n" "$$f" >> dump.txt; \
		cat "$$f" >> dump.txt; \
		printf "\n\n" >> dump.txt; \
	done
	@echo "Wrote dump.txt"

