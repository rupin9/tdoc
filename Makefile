# Makefile for tdoc
#
# This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
# International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
#
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# Description:
#
# This Makefile is designed to automate the process of building and packaging
# the documentation. It supports multiple build targets
# for generating documentation in various formats (PDF, HTML, EPUB).
#

TDOC ?= chisel
DT ?= html

ifeq ($(TDOC), ca)
  DOCS ?= ca-study.adoc
else
  DOCS := chisel-study.adoc
endif

RELEASE_TYPE ?= draft

ifeq ($(RELEASE_TYPE), draft)
  WATERMARK_OPT := -a draft-watermark
  RELEASE_DESCRIPTION := DRAFT---NOT AN OFFICIAL RELEASE
else ifeq ($(RELEASE_TYPE), intermediate)
  WATERMARK_OPT :=
  RELEASE_DESCRIPTION := Intermediate Release
else ifeq ($(RELEASE_TYPE), official)
  WATERMARK_OPT :=
  RELEASE_DESCRIPTION := Official Release
else
  $(error Unknown build type; use RELEASE_TYPE={draft, intermediate, official})
endif

DATE ?= $(shell date +%Y-%m-%d)
VERSION ?= v0.1.0

SRC_DIR := src
BUILD_DIR := build

#DOCS_PDF := $(addprefix $(BUILD_DIR)/, $(addsuffix .pdf, $(DOCS)))
#DOCS_HTML := $(addprefix $(BUILD_DIR)/, $(addsuffix .html, $(DOCS)))
#DOCS_EPUB := $(addprefix $(BUILD_DIR)/, $(addsuffix .epub, $(DOCS)))
DOCS_HTML := $(DOCS:%.adoc=%.html)
DOCS_PDF := $(DOCS:%.adoc=%.pdf)
DOCS_EPUB := $(DOCS:%.adoc=%.epub)

ENV := LANG=C.utf8
XTRA_ADOC_OPTS :=
ASCIIDOCTOR_HTML := $(ENV) asciidoctor
ASCIIDOCTOR_PDF := $(ENV) asciidoctor-pdf
ASCIIDOCTOR_EPUB := $(ENV) asciidoctor-epub3

OPTIONS := --trace \
           -a compress \
           -a mathematical-format=svg \
           -a pdf-fontsdir=docs-resources/fonts \
           -a pdf-theme=docs-resources/themes/riscv-pdf.yml \
           $(WATERMARK_OPT) \
           -a revnumber='$(VERSION)' \
           -a revremark='$(RELEASE_DESCRIPTION)' \
           -a revdate=${DATE} \
           $(XTRA_ADOC_OPTS) \
           -D build \
           --failure-level=WARN
REQUIRES := --require=asciidoctor-bibtex \
            --require=asciidoctor-diagram \
            --require=asciidoctor-lists \
            --require=asciidoctor-mathematical \
            --require=asciidoctor-sail

.PHONY: all build clean build-docs

all: build

ifeq ($(DT), epub)
build-docs: $(DOCS_HTML) $(DOCS_PDF) $(DOCS_EPUB)
else ifeq ($(DT), pdf)
build-docs: $(DOCS_HTML) $(DOCS_PDF) 
else
build-docs: $(DOCS_HTML)
endif

vpath %.adoc $(SRC_DIR)
#ALL_SRCS := $(wildcard $(SRC_DIR)/*.adoc)

%.html: %.adoc
	$(ASCIIDOCTOR_HTML) $(OPTIONS) $(REQUIRES) $<

%.pdf: %.adoc
	$(ASCIIDOCTOR_PDF) $(OPTIONS) $(REQUIRES) $<

%.epub: %.adoc
	$(ASCIIDOCTOR_EPUB) $(OPTIONS) $(REQUIRES) $<

build:
	@echo "Starting build..."
	$(MAKE) build-docs
	@echo "Build completed successfully."

clean:
	@echo "Cleaning up generated files..."
	rm -rf $(BUILD_DIR)
	@echo "Cleanup completed."

new: clean
	$(MAKE)
