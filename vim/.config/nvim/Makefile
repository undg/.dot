.PHONY: test test/watch

test: 
	nvim --headless -c "PlenaryBustedDirectory spec/"

test/watch:
	find -name '*.lua' | entr -c nvim --headless -c "PlenaryBustedDirectory spec/"

test/watch/file:
	@find spec -name '*.lua' | fzf --prompt="Select file to watch: " | xargs -I {} sh -c 'find -name "*.lua" | entr -c nvim --headless -c "PlenaryBustedFile {}" || echo "File not found: {}"'
