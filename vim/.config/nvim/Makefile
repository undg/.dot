.PHONY: test test/watch

test: 
	nvim --headless -c "PlenaryBustedDirectory spec/"

test/watch:
	find -name '*.lua' | entr -c nvim --headless -c "PlenaryBustedDirectory spec/"

test/watch/file:
	@read -p "Enter file to watch: " file; \
	find -name '*.lua' | entr -c nvim --headless -c "PlenaryBustedFile $$file" || echo "File not found: $$file"
