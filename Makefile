#!/usr/bin/make

OUTDIR=output/web
HTML=$(OUTDIR)/index.html $(OUTDIR)/personal.html $(OUTDIR)/programming.html \
     $(OUTDIR)/amilo.html $(OUTDIR)/all_news.html $(OUTDIR)/stuff.rss
XSLT=xsltproc --xinclude
XSLT_SIMPLE= -o $@ simple.xsl main.xml
ALL_FILES=*.xml *.xsl

all: $(HTML)

clean:
	rm -f $(HTML)

crlf2lf:
	find $(OUTDIR) -name "*.html" | xargs dos2unix

$(OUTDIR)/index.html:
	$(XSLT) --stringparam itemnode home $(XSLT_SIMPLE)

$(OUTDIR)/personal.html:
	$(XSLT) --stringparam itemnode personal $(XSLT_SIMPLE)

$(OUTDIR)/programming.html:
	$(XSLT) --stringparam itemnode programming $(XSLT_SIMPLE)

$(OUTDIR)/amilo.html:
	$(XSLT) --stringparam itemnode amilo $(XSLT_SIMPLE)

$(OUTDIR)/all_news.html:
	$(XSLT) --stringparam itemnode all-news $(XSLT_SIMPLE)

$(OUTDIR)/stuff.rss:
	$(XSLT) -o $@ news_rss.xsl main.xml

.SUFFIXES: .xml .xsl .html

$(OUTDIR)/*.html $(OUTDIR)/*.rss: $(ALL_FILES) Makefile