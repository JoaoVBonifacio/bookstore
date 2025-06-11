PYTHON_VERSION ?= 3.8.10
LIBRARY_DIRS = mylibrary
BUILD_DIR ?= build

PYTEST_HTML_OPTIONS = --html=$(BUILD_DIR)/report.html --self-contained-html
PYTEST_TAP_OPTIONS = --tap-combined --tap-outdir $(BUILD_DIR)
PYTEST_COVERAGE_OPTIONS = --cov=$(LIBRARY_DIRS)
PYTEST_OPTIONS ?= $(PYTEST_HTML_OPTIONS) $(PYTEST_TAP_OPTIONS) $(PYTEST_COVERAGE_OPTIONS)

MYPY_OPTS ?= --python-version $(basename $(PYTHON_VERSION)) --show-column-numbers --pretty --html-report $(BUILD_DIR)/mypy

PYTHON_VERSION_FILE = .python-version
PIP ?= pip
POETRY_OPTS ?=
POETRY ?= poetry $(POETRY_OPTS)
RUN_PYPKG_BIN = $(POETRY) run

.PHONY: help
help:
	@echo.
	@echo Usage:
	@echo    make test             - Run tests
	@echo    make check            - Run code quality checks
	@echo    make build            - Build the package
	@echo    make publish          - Publish the package
	@echo    make deps             - Install all dependencies
	@echo    make format-py        - Auto format Python code
	@echo    make migrate          - Run Django migrations
	@echo    make seed             - Run Django seed script
	@echo.

.PHONY: version-python
version-python:
	@echo $(PYTHON_VERSION)

.PHONY: test
test:
	$(RUN_PYPKG_BIN) pytest $(PYTEST_OPTIONS) tests/*.py

.PHONY: build
build:
	$(POETRY) build

.PHONY: publish
publish:
	$(POETRY) publish $(POETRY_PUBLISH_OPTIONS_SET_BY_CI_ENV)

.PHONY: deps
deps: deps-py

.PHONY: deps-py
deps-py:
	$(PIP) install --upgrade pip
	$(PIP) install --upgrade poetry
	$(POETRY) install

.PHONY: check
check: check-py

.PHONY: check-py
check-py: check-py-flake8 check-py-black check-py-mypy

.PHONY: check-py-flake8
check-py-flake8:
	$(RUN_PYPKG_BIN) flake8 .

.PHONY: check-py-black
check-py-black:
	$(RUN_PYPKG_BIN) black --check --line-length 118 --fast .

.PHONY: check-py-mypy
check-py-mypy:
	$(RUN_PYPKG_BIN) mypy $(MYPY_OPTS) $(LIBRARY_DIRS)

.PHONY: format-py
format-py:
	$(RUN_PYPKG_BIN) black .

.PHONY: format-autopep8
format-autopep8:
	$(RUN_PYPKG_BIN) autopep8 --in-place --recursive .

.PHONY: format-isort
format-isort:
	$(RUN_PYPKG_BIN) isort --recursive .

.PHONY: migrate
migrate:
	poetry run python manage.py migrate --noinput

.PHONY: seed
seed:
	poetry run python manage.py seed
