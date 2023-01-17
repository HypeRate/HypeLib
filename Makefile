.PHONY: install \
		clear \
		compile \
		test \
		watch-raw \
		watch \
		watch-docs

install: clear
	mix do deps.get, deps.compile

clear:
	cls || clear

compile:
	mix compile

docs:
	mix docs

test:
	mix test --color

watch-raw:
	npx concurrently "make test" "make docs"

watch:
	npx onchange -i -k "lib/**/*.ex" "test/**/*.exs" -- make clear watch-raw

watch-tests:
	npx onchange -i -k "lib/**/*.ex" "test/**/*.exs" -- make clear test

watch-docs:
	npx onchange -i -k "lib/**/*.ex" -- make clear docs
