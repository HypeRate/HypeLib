.PHONY: install \
		clear \
		compile \
		test \
		watch

install: clear
	mix do deps.get, deps.compile

clear:
	cls || clear

compile:
	mix compile

test:
	mix test --color

watch:
	npx onchange -i -k "lib/**/*.ex" -- make clear test
