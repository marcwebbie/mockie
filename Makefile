PACKAGE = "mockie"
PACKAGE_TESTS = "tests"


.PHONY: clean coverage test

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  clean		=> to clean clean all automatically generated files"
	@echo "  coverage	=> to run coverage"
	@echo "  dist		=> to build $(PACKAGE)"
	@echo "  register	=> to update metadata on pypi servers"
	@echo "  check		=> to check code for smells"
	@echo "  test		=> to run all tests on python $(PY34)"
	@echo "  test-py2	=> to run all tests on python $(PY27)"
	@echo "  test-pypy	=> to run all tests on python $(PYPY)"
	@echo "  deploy		=> to push binary wheels to pypi servers"


clean:
	find $(PACKAGE) -name \*.pyc -delete
	find $(PACKAGE) -name \*__pycache__ -delete
	find $(PACKAGE_TESTS) -name \*.pyc -delete
	find $(PACKAGE_TESTS) -name \*__pycache__ -delete
	python setup.py clean --all --quiet || true
	rm MANIFEST || true
	rm -rf build-* || true
	rm -rf *egg* || true
	rm -rf dist || true
	rm -rf __pycache__ || true

dist:
	python setup.py -q sdist
	python setup.py -q bdist_egg
	python setup.py -q bdist_wheel

	@echo
	@echo "Build files [dist]:"
	@echo "--------------------------"
	@ls -l ./dist/

register:
	python setup.py register

check:
	flake8 $(PACKAGE) $(PACKAGE_TESTS)

coverage:
	pip install coverage
	coverage run --source=$(PACKAGE) setup.py test
	coverage report -m

test:
	python setup.py test
