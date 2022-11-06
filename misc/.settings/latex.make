# Use bash instead of sh
SHELL := bash

# Spawn one shell per rule instead of one per line
.ONESHELL:

# Ensure that bash runs in strict mode
.SHELLFLAGS := -eu -o pipefail -c

# Delete any generated files on errors
.DELETE_ON_ERROR:

# Warn if using an undefined variable
MAKEFLAGS += --warn-undefined-variables

# Remove all "magic" rules
MAKEFLAGS += --no-builtin-rules

# Use "> " instead of tabs for indents in rules
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

## biber
BIBCC:=biber
BIBCC_FLAGS:='--input-directory latex.out'

## latexrun
LATEXCC:=latexrun
LATEXCC_FLAGS:=--bibtex-cmd $(BIBCC) --bibtex-args $(BIBCC_FLAGS)
CLEAN_FLAGS:=--clean-all

all: $(INPUTFILE).pdf
> $(LATEXCC) $(LATEXCC_FLAGS) $(INPUTFILE)

$(INPUTFILE).pdf:
> $(LATEXCC) $(LATEXCC_FLAGS) $(INPUTFILE)

.PHONY: clean
clean:
> $(LATEXCC) $(CLEAN_FLAGS)

.PHONY: view
view: $(INPUTFILE).pdf layout
> @open $(INPUTFILE).pdf

.PHONY: open
open:
> @/usr/local/bin/subl --project $(INPUTFILE).sublime-project

.PHONY: close
close:
> @/usr/local/bin/subl --command close_workspace

.PHONY: layout
layout:
> @open -g hammerspoon://desktopWriting
