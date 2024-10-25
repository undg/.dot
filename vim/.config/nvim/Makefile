.PHONY: test test/watch

test: 
	nvim --headless -c "PlenaryBustedDirectory spec/"

test/watch:
	find -name '*.lua' | entr -c nvim --headless -c "PlenaryBustedDirectory spec/"

