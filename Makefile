.PHONY: default pull report2013 site

default: site

pull:
	git pull
	git submodule update --remote

report2013: reports/2013/Makefile
	make -C reports/2013

reports/2013/Makefile:
	git submodule init
	git submodule update --remote

site: report2013
	jekyll build
