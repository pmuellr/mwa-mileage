#-------------------------------------------------------------------------------
# Copyright (c) 2010 Patrick Mueller
# Licensed under the MIT license: 
# http://www.opensource.org/licenses/mit-license.php
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# nothing to do for a normal build
#-------------------------------------------------------------------------------
all: help

#-------------------------------------------------------------------------------
# build development version
#-------------------------------------------------------------------------------
build-dev:
	@echo
	@echo ----------------------------------------------------------------------
	@echo make build-dev starting
	@echo ----------------------------------------------------------------------

	@# clean tmp dir
	@rm -rf tmp
	@mkdir  tmp

	@# clean build dir
	@rm -rf build
	@mkdir  build

	@# copy stuff over to build
	cp mwa-mileage.html build 
	cp mwa-mileage.css  build 
	
	cp -R images build
	
	cp -R vendor build
	rm build/vendor/scooj/*.py
	rm build/vendor/modjewel/*.py

	@# create tmp/modules
	mkdir tmp/modules
	
	@# convert scoop modules to js in tmp/modules
	python vendor/scooj/scoopc.py --out tmp/modules modules
	
	@# transportd-ize tmp/modules to build/modules
	python vendor/modjewel/module2transportd.py --out build/modules tmp/modules
	
	@# transportd-ize scooj to build, remove original source from build
	python vendor/modjewel/module2transportd.py --out build/vendor/scooj vendor/scooj
	rm build/vendor/scooj/scooj.js

	@# transportd-ize backbone to build, remove original source from build
	python vendor/modjewel/module2transportd.py --out build/vendor/backbone vendor/backbone
	rm build/vendor/backbone/backbone.js

	@# transportd-ize underscore to build, remove original source from build
	python vendor/modjewel/module2transportd.py --out build/vendor/underscore vendor/underscore
	rm build/vendor/underscore/underscore.js

	@echo ----------------------------------------------------------------------
	@echo make build-dev finished
	@echo ----------------------------------------------------------------------

#-------------------------------------------------------------------------------
# build release
#-------------------------------------------------------------------------------
build-release:
	@echo TBD

#-------------------------------------------------------------------------------
# get vendor resources
#-------------------------------------------------------------------------------
get-vendor:
	@rm -rf vendor
	@mkdir  vendor

	mkdir   vendor/modjewel
	curl -o vendor/modjewel/modjewel-require.js  $(MODJEWEL_URL)/$(MODJEWEL_VERSION)/modjewel-require.js 
	curl -o vendor/modjewel/module2transportd.py $(MODJEWEL_URL)/$(MODJEWEL_VERSION)/module2transportd.py

	mkdir   vendor/scooj
	curl -o vendor/scooj/scooj.js  $(SCOOJ_URL)/$(SCOOJ_VERSION)/scooj.js
	curl -o vendor/scooj/scoopc.py $(SCOOJ_URL)/$(SCOOJ_VERSION)/scoopc.py

	mkdir   vendor/underscore
	curl -o vendor/underscore/underscore.js  $(UNDERSCORE_URL)/$(UNDERSCORE_VERSION)/underscore.js

	mkdir   vendor/backbone
	curl -o vendor/backbone/backbone.js  $(BACKBONE_URL)/$(BACKBONE_VERSION)/backbone.js

	mkdir   vendor/jquery
	curl -o vendor/jquery/jquery.js         $(JQUERY_URL)/jquery-$(JQUERY_VERSION).js
	
	mkdir   vendor/run-when-changed
	curl -o vendor/run-when-changed/run-when-changed.py $(RUN_WHEN_CHANGED_URL)

#-------------------------------------------------------------------------------
# remove crap
#-------------------------------------------------------------------------------
clean:
	rm -rf tmp
	rm -rf build

#-------------------------------------------------------------------------------
# see: https://gist.github.com/240922
#-------------------------------------------------------------------------------
watch:
	python vendor/run-when-changed/run-when-changed.py "make build-dev" *

#-------------------------------------------------------------------------------
# print some help
#-------------------------------------------------------------------------------
help:
	@echo make targets available:
	@echo \  clean
	@echo \  watch
	@echo \  get-vendor

#-------------------------------------------------------------------------------
# vendor info
#-------------------------------------------------------------------------------

MODJEWEL_URL           = https://github.com/pmuellr/modjewel/raw
MODJEWEL_VERSION       = master

SCOOJ_URL              = https://github.com/pmuellr/scooj/raw
SCOOJ_VERSION          = master

UNDERSCORE_URL         = https://github.com/documentcloud/underscore/raw
UNDERSCORE_VERSION     = 1.1.2

BACKBONE_URL           = https://github.com/documentcloud/backbone/raw
BACKBONE_VERSION       = 0.3.2

JQUERY_URL             = http://code.jquery.com
JQUERY_VERSION         = 1.4.4

RUN_WHEN_CHANGED_URL   = https://gist.github.com/raw/240922/0f5bedfc42b3422d0dee81fb794afde9f58ed1a6/run-when-changed.py