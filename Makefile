#!/usr/bin/make

OUTDIR=../site/web
HTML=$(OUTDIR)/index.html $(OUTDIR)/personal.html $(OUTDIR)/programming.html \
     $(OUTDIR)/amilo.html
XSLT=xsltproc --xinclude
XMLCHECKDTD=xmllint --catalogs --loaddtd --valid --noout
XMLCHECK=xmllint --catalogs --noout
ALL_FILES=*.xml *.xsl

all: $(HTML)

crlf2lf:
	find $(OUTDIR) -name "*.html" | xargs dos2unix

$(OUTDIR)/index.html:
	$(XSLT) -o $@ --stringparam itemnode home home.xsl main.xml

$(OUTDIR)/personal.html:
	$(XSLT) -o $@ --stringparam itemnode personal home.xsl main.xml

$(OUTDIR)/programming.html:
	$(XSLT) -o $@ --stringparam itemnode programming home.xsl main.xml

$(OUTDIR)/amilo.html:
	$(XSLT) -o $@ --stringparam itemnode amilo home.xsl main.xml

# $(OUTDIR)/sshot01.html: sshots.xml sshots.xsl wxperl.xsl
# 	$(XSLT) --stringparam page 1 -o $@ sshots.xsl sshots.xml

test:
	$(XMLCHECKDTD) applications.xml
	$(XMLCHECK) main.xml
	$(XMLCHECKDTD) sshots.xml
	$(XMLCHECKDTD) tutorial/tutorial.xml

.SUFFIXES: .xml .xsl .html

$(OUTDIR)/*.html: $(ALL_FILES)