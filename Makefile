.PHONY: default pull report2013 site

default: site

pull:
	git pull
	git submodule update --remote

report2013:
	make -C reports/2013

site: report2013
	jekyll build
