.PHONY: install \
		clear \
		compile \
		test \
		coverage \
		coverage-report \
		watch-raw \
		watch \
		watch-docs \
		watch-credo \
		watch-coverage-report

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

credo:
	mix credo

coverage:
	MIX_ENV=test mix coveralls

coverage-report:
	MIX_ENV=test mix coveralls.html

watch-raw:
	npx concurrently "make test" "make docs" "make credo" "make coverage-report"

watch:
	npx onchange -i -k "lib/**/*.ex" "test/**/*.exs" -- make clear watch-raw

watch-tests:
	npx onchange -i -k "lib/**/*.ex" "test/**/*.exs" -- make clear test

watch-docs:
	npx onchange -i -k "lib/**/*.ex" -- make clear docs

watch-credo:
	npx onchange -i -k "lib/**/*.ex" -- make clear credo

watch-coverage-report:
	npx onchange -i -k "lib/**/*.ex" -- make clear coverage-report
