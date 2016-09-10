all:
	coffee -o lib/ -c src/
	coffee -o public/scripts/ -c client-src/

watch:
	coffee -o lib/ -cw src/
	coffee -o public/scripts/ -cw client-src/

clean:
	rm -rf lib/

.PHONY: all watch clean
