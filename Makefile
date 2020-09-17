DOMAIN="arewedistributedyet.com"

IPFSLOCAL="http://localhost:8080/ipfs/"
IPFSGATEWAY="https://dweb.link/ipfs/"
NPM=npm
NPMBIN=./node_modules/.bin
OUTPUTDIR=public

ifeq ($(DEBUG), true)
	PREPEND=
	APPEND=
else
	PREPEND=@
	APPEND=1>/dev/null
endif

build: clean install lint css js logos minify
	$(PREPEND)hugo && \
	echo "" && \
	echo "Site built out to ./public dir"

help:
	@echo 'Makefile for ipld.io, a hugo built static site.                                                          '
	@echo '                                                                                                          '
	@echo 'Usage:                                                                                                    '
	@echo '   make                                Build the optimised site to ./$(OUTPUTDIR)                         '
	@echo '   make serve                          Preview the production ready site at http://localhost:1313         '
	@echo '   make lint                           Check your JS and CSS are ok                                       '
	@echo '   make js                             Copy the *.js to ./static/js                                 '
	@echo '   make css                            Compile the *.css to ./static/css                                 '
	@echo '   make minify                         Optimise all the things!                                           '
	@echo '   make dev                            Start a hot-reloding dev server on http://localhost:1313           '
	@echo '   make deploy                         Add the website to your local IPFS node                            '
	@echo '   make clean                          remove the generated files                                         '
	@echo '                                                                                                          '
	@echo '   DEBUG=true make [command] for increased verbosity                                                      '

serve: install lint js css minify
	$(PREPEND)hugo server

node_modules:
	$(PREPEND)$(NPM) i $(APPEND)

install: node_modules
	$(PREPEND)[ -d static/css ] || mkdir -p static/css && \
	[ -d static/js ] || mkdir -p static/js

lint: install
	$(PREPEND)$(NPMBIN)/standard layouts && $(NPMBIN)/lessc --lint less/*

css: install
	$(PREPEND)$(NPMBIN)/lessc --clean-css --autoprefix less/main.less static/css/main.css $(APPEND)

js: install
	$(PREPEND)cp -r js/ static/js || true $(APPEND)

logos: install
	$(PREPEND)cp node_modules/@browser-logos/*/*_256x256.png static/img/browser-logos/ || true $(APPEND)

minify: install minify-js minify-img

minify-js: install
	$(PREPEND)find static/js -name '*.js' -exec $(NPMBIN)/uglifyjs {} --compress --output {} $(APPEND) \;

minify-img: install
	$(PREPEND)find static/img -type d -exec $(NPMBIN)/imagemin {}/* --out-dir={} || true $(APPEND) \;

dev: install css js
	$(PREPEND)( \
		$(NPMBIN)/nodemon --watch less -e less --exec "$(NPMBIN)/lessc --clean-css --autoprefix less/main.less static/css/main.css" & \
		hugo server -w \
	)

deploy:
	$(PREPEND)$(NPM) run deploy $(APPEND)

clean:
	$(PREPEND)[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR) && \
	[ ! -d static/css ] || rm -rf static/css/*.css && \
	[ ! -d static/js ] || rm -rf static/js/*.js

.PHONY: build help install lint css js minify minify-js minify-img  dev stopdev deploy clean
