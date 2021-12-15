
fmt: unify isort black

unify:
	unify --in-place --recursive .

isort:
	isort .

black:
	black .

lint: flake8 pylint bandit

flake8:
	flake8 .

pylint:
	pylint modsecurity tests

bandit:
	bandit -r .

clean:
	rm -rf build dist wheelhouse *.egg-info $$(find -name __pycache__ -o -name '*.cpp')

build-image:
	docker build -t modsecurity-build .

container:
	docker run -it -v $$PWD:/srv -w /srv modsecurity-build:latest sh

bdist_wheel:
	docker run -it -e UIDGID=$$(id -u):$$(id -g) -v $$PWD:/srv -w /srv modsecurity-build:latest ./bdist_wheel.sh

.PHONY: fmt unify isort black
