Title: Some XSLT tricks
Date-Rfc822: Sun, 07 Dec 2008 01:13:52 +0100
Description: Some non trivial (and in part non standard...)
  XSLT rechniques I discovered while trying to sort dates

EXSLT
-----

First of all, if you need to work with an XSLT 1.0 processor (such as
xsltproc/libxslt), [EXSLT](http://www.exslt.org/) defines some **non
standard** extensions to XSLT for string and date manipulation,
user-defined functions, and more.

Mappings
--------

Stolen from <http://kpumuk.info/xslt/sorting-rss-feed-by-date-using-xslt/>:

    <map>
      <item key="a" value="1" />
      <item key="b" value="2" />
      <!-- ... -->
    </map>
  
    <xsl:variable name="myMap" select="document('')/*/map"/>
    <xsl:value-of select="$myMap/*[@key='b']/@value" />

Allows storing arbitrary mappings inside an XML/XSLT document.
