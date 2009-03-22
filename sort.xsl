<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:func="http://exslt.org/functions"
  xmlns:str="http://exslt.org/strings"
  xmlns:months="http://barbon.org/my/months"
  xmlns:my="http://barbon.org/my"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  extension-element-prefixes="date func str">

<!-- taken from http://kpumuk.info/xslt/sorting-rss-feed-by-date-using-xslt/
     and modified to suit my needs -->
<months:months>
  <month name="Jan" index="01" fullname="January" />
  <month name="Feb" index="02" fullname="February" />
  <month name="Mar" index="03" fullname="March" />
  <month name="Apr" index="04" fullname="April" />
  <month name="May" index="05" fullname="May" />
  <month name="Jun" index="06" fullname="June" />
  <month name="Jul" index="07" fullname="July" />
  <month name="Aug" index="08" fullname="August" />
  <month name="Sep" index="09" fullname="September" />
  <month name="Oct" index="10" fullname="October" />
  <month name="Nov" index="11" fullname="November" />
  <month name="Dec" index="12" fullname="December" />
</months:months>

<xsl:variable name="vMonths" select="document('')/*/months:*"/>

<func:function name="my:date-rfc822">
  <xsl:param name="date" />
  <xsl:variable name="month"><xsl:value-of select="str:split(date/@rfc822)[position() = 3]" /></xsl:variable>
  <func:result>
    <xsl:value-of select="str:split(date/@rfc822)[position() = 4]" />-<xsl:value-of select="$vMonths/*[@name=$month]/@index" />-<xsl:value-of select="str:split(date/@rfc822)[position() = 2]" />T<xsl:value-of select="str:split(date/@rfc822)[position() = 5]" /><xsl:value-of select="str:split(date/@rfc822)[position() = 6]" />
  </func:result>
</func:function>

<func:function name="my:year-rfc822">
  <xsl:param name="date" />
  <func:result>
    <xsl:value-of select="str:split(date/@rfc822)[position() = 4]" />
  </func:result>
</func:function>

<func:function name="my:day-rfc822">
  <xsl:param name="date" />
  <func:result>
    <xsl:value-of select="str:split(date/@rfc822)[position() = 2]" />
  </func:result>
</func:function>

<func:function name="my:longmonth-rfc822">
  <xsl:param name="date" />
  <xsl:variable name="month"><xsl:value-of select="str:split(date/@rfc822)[position() = 3]" /></xsl:variable>
  <func:result>
    <xsl:value-of select="$vMonths/*[@name=$month]/@fullname" />
  </func:result>
</func:function>

</xsl:stylesheet>
