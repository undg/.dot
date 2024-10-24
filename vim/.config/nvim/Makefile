.PHONY: install test test/watch

install:
	luarocks install --only-deps nvim-scm-1.rockspec

test:
	busted

test/watch:
	find -name '*.lua' | entr -c busted
