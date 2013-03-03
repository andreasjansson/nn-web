#see http://ryanflorence.com/2012/coffeescript-source-maps/

%.js: %.coffee
	coffee -c $<
#	coffee --js -i $< -o $@
#	coffeeredux --source-map -i $< -o $@.map
#	(echo; echo '//@ sourceMappingURL=$@.map') >> $@

all: $(addsuffix .js, $(basename $(wildcard *.coffee)))

clean:
	rm *.js

watch:
	while true; do inotifywait -e modify -e move -e create -e delete *.coffee; make; done
