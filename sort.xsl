<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  xmlns:months="http://barbon.org/dummy/months"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- taken from http://kpumuk.info/xslt/sorting-rss-feed-by-date-using-xslt/
     and modified to suit my needs -->
<months:months>
  <month name="Jan" index="0" fullname="january" />
  <month name="Feb" index="1" fullname="february" />
  <month name="Mar" index="2" fullname="march" />
  <month name="Apr" index="3" fullname="april" />
  <month name="May" index="4" fullname="may" />
  <month name="Jun" index="5" fullname="june" />
  <month name="Jul" index="6" fullname="july" />
  <month name="Aug" index="7" fullname="august" />
  <month name="Sep" index="8" fullname="september" />
  <month name="Oct" index="9" fullname="october" />
  <month name="Nov" index="10" fullname="november" />
  <month name="Dec" index="11" fullname="december" />
</months:months>

<xsl:sort select="substring(substring-after(substring-after(substring-after(date/@rfc822, ' '), ' '), ' '), 1, 4)" order="descending"/>
<xsl:sort select="$vMonths/*[@name=substring(substring-after(substring-after(current()/date/@rfc822, ' '), ' '), 1, 3)]/@index"
          data-type="number"
          order="descending" />
<xsl:sort select="substring(substring-after(date/@rfc822, ' '), 1, 2)" data-type="number" order="descending" />
<xsl:sort select="substring(substring-after(substring-after(substring-after(substring-after(date/@rfc822, ' '), ' '), ' '), ' '), 1, 8)" data-type="text" order="descending" />

</xsl:stylesheet>
