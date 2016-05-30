all:
	coffee -o lib/ -c src/

watch:
	coffee -o lib/ -cw src/

clean:
	rm -rf lib/

test:
	mocha -c --compilers coffee:coffee-script/register
.PHONY: all watch clean test
