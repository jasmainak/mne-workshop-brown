.PHONY: help book clean serve

help:
	@echo "Please use 'make <target>' where <target> is one of:"
	@echo "  install     to install the necessary dependencies for jupyter-book to build"
	@echo "  book        to convert the `content/` folder into Jekyll markdown in `_build/`"
	@echo "  clean       to clean out site build files"
	@echo "  runall      to run all notebooks in-place, capturing outputs with the notebook"
	@echo "  serve       to serve the repository locally with Jekyll"
	@echo "  build       to build the site HTML locally with Jekyll and store in _site/"


install:
	gem install bundler
	bundle install

book:
	jupyter-book build ./

runall:
	jupyter-book run ./content

clean:
	python scripts/clean.py

serve:
	bundle exec guard

site:
	bundle exec jekyll build
	touch _site/.nojekyll

copypush:
	git clone -b master --single-branch --no-checkout --depth 1 git@github.com:jasmainak/mne-workshop-brown.git content_master/
	cp -r content/* content_master && \
	sed -i 's/readme/readme.md/g' content_master/readme.md && \
	sed -i 's/)/.ipynb)/g' content_master/raw_to_evoked/readme.md && \
	cd content_master && \
	git add * && \
	git commit -a -m 'Copy from gh-pages' && \
	git push
