.PHONY: all clean joplin joplin-clone joplin-update

JOPLIN_REPO ?= https://github.com/laurent22/joplin.git
JOPLIN_REF ?= dev
JOPLIN_BUILD_REF ?= "$(shell basename $(PWD))_$(shell date +"%Y%m%d%H%M")"

all: joplin

joplin-clone:
	git clone "$(JOPLIN_REPO)" joplin

joplin-update:
	git -C joplin fetch origin "$(JOPLIN_REF)"
	git -C joplin switch --force-create "$(JOPLIN_BUILD_REF)" "origin/$(JOPLIN_REF)"

joplin:
	test -e joplin || $(MAKE) joplin-clone
	$(MAKE) joplin-update

