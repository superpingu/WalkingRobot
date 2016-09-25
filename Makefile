distantrun:
	pirun pi3 . run

distantinstall:
	pirun pi3 . install

off:
	pirun pi3 . shutdown

shutdown:
	sudo shutdown -h now

compile:
	coffee -o lib/ -c src/

install:
	npm install

run: compile
	sudo node lib/app.js

watch:
	coffee -o lib/ -cw src/

clean:
	rm -rf lib/

.PHONY: compile watch clean run distantrun install off shutdown
