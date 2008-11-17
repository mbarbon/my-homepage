#!/usr/bin/make

OUTDIR=../site
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
	$(XSLT) -o $@ home.xsl main.xml

$(OUTDIR)/personal.html:
	$(XSLT) -o $@ personal.xsl main.xml

$(OUTDIR)/programming.html:
	$(XSLT) -o $@ programming.xsl main.xml

$(OUTDIR)/amilo.html:
	$(XSLT) -o $@ amilo.xsl main.xml

# $(OUTDIR)/sshot01.html: sshots.xml sshots.xsl wxperl.xsl
# 	$(XSLT) --stringparam page 1 -o $@ sshots.xsl sshots.xml

test:
	$(XMLCHECKDTD) applications.xml
	$(XMLCHECK) main.xml
	$(XMLCHECKDTD) sshots.xml
	$(XMLCHECKDTD) tutorial/tutorial.xml

.SUFFIXES: .xml .xsl .html

$(OUTDIR)/*.html: $(ALL_FILES)