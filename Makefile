#!/usr/bin/make

OUTDIR=output/web
HTML=$(OUTDIR)/index.html $(OUTDIR)/personal.html $(OUTDIR)/programming.html \
     $(OUTDIR)/amilo.html $(OUTDIR)/all_news.html $(OUTDIR)/stuff.rss \
     $(OUTDIR)/old/stuff.html $(OUTDIR)/2008/stuff.html \
     $(OUTDIR)/2009/stuff.html $(OUTDIR)/perl.rss

MARKDOWN=$(wildcard */*.md)
XSLT=xsltproc --xinclude
XSLT_SIMPLE= -o $@ simple.xsl main.xml
ALL_FILES=*.xml *.xsl *.dtd $(patsubst %.md,%.xml,$(MARKDOWN))
YEAR=2009

%.xml: %.md process.pl
	perl process.pl $< $@

$(OUTDIR)/%.html: NODE=$(*F)

$(OUTDIR)/%/%.html: BASEPATH=--stringparam basepath '../'

$(OUTDIR)/%/stuff.html: NODE=all-news
$(OUTDIR)/%/stuff.html: YEAR=$(*D)
$(OUTDIR)/%/stuff.html: BASEPATH=--stringparam basepath '../'

$(OUTDIR)/%.rss:
	$(XSLT) --stringparam tag $(TAG) -o $@ news_rss.xsl main.xml

$(OUTDIR)/%.html:
	$(XSLT) $(BASEPATH) --stringparam itemnode $(NODE) --stringparam year $(YEAR) $(XSLT_SIMPLE)

all: $(HTML)

clean:
	rm -f $(HTML)

archive: all
	WHERE=`pwd` && cd $(OUTDIR) && tar cjf $$WHERE/web.tar.bz2 * .htaccess

upload: archive
	perl ../bin/client_hv.pl --file=web.tar.bz2

crlf2lf:
	find $(OUTDIR) -name "*.html" | xargs dos2unix

markdown.xml: $(MARKDOWN)
	perl -e 'BEGIN{print qq{<data xmlns:xi="http://www.w3.org/2001/XInclude">}};' \
	     -e 'END{print"</data>"};' \
	     -e 's/\.md$$/.xml/, print qq{<xi:include href="$$_" />} foreach glob "*/*.md"' > markdown.xml

$(OUTDIR)/index.html: NODE=home
$(OUTDIR)/all_news.html: NODE=all-news
$(OUTDIR)/stuff.rss: TAG=all
$(OUTDIR)/perl.rss: TAG=perl

$(OUTDIR)/old/stuff.html: NODE=old-news
$(OUTDIR)/old/stuff.html: BASEPATH=--stringparam basepath '../'

.SUFFIXES: .xml .xsl .html

$(HTML): $(ALL_FILES) Makefile
