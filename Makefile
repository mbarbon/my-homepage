#!/usr/bin/make

OUTDIR=../site/web
HTML=$(OUTDIR)/index.html $(OUTDIR)/personal.html $(OUTDIR)/programming.html \
     $(OUTDIR)/amilo.html $(OUTDIR)/all_news.html
XSLT=xsltproc --xinclude
XMLCHECKDTD=xmllint --catalogs --loaddtd --valid --noout
XMLCHECK=xmllint --catalogs --noout
ALL_FILES=*.xml *.xsl

all: $(HTML)

crlf2lf:
	find $(OUTDIR) -name "*.html" | xargs dos2unix

$(OUTDIR)/index.html:
	$(XSLT) -o $@ --stringparam itemnode home simple.xsl main.xml

$(OUTDIR)/personal.html:
	$(XSLT) -o $@ --stringparam itemnode personal simple.xsl main.xml

$(OUTDIR)/programming.html:
	$(XSLT) -o $@ --stringparam itemnode programming simple.xsl main.xml

$(OUTDIR)/amilo.html:
	$(XSLT) -o $@ --stringparam itemnode amilo simple.xsl main.xml

$(OUTDIR)/all_news.html:
	$(XSLT) -o $@ --stringparam itemnode all-news simple.xsl main.xml

.SUFFIXES: .xml .xsl .html

$(OUTDIR)/*.html: $(ALL_FILES) Makefile