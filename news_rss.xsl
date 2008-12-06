<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  exclude-result-prefixes="xhtml"
  xmlns:months="http://barbon.org/dummy/months"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="vMonths" select="document('sort.xsl')/*/months:*"/>

<xsl:output method="xml"
            indent="yes"
            encoding="utf-8"
            />

<!-- pass-through xhtml:*, stripping all tags -->
<xsl:template match="xhtml:*">
  <xsl:apply-templates />
</xsl:template>

<!-- news item -->
<xsl:template match="item">
  <item>
    <xsl:if test="title">
      <title><xsl:apply-templates select="title" /></title>
    </xsl:if>
    <description>
      <xsl:choose>
        <xsl:when test="description">
          <xsl:apply-templates select="description" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="content" />
        </xsl:otherwise>
      </xsl:choose>
    </description>
    <pubDate><xsl:value-of select="date/@rfc822" /></pubDate>
    <xsl:variable name="newsyear">
      <xsl:value-of select="substring(substring-after(substring-after(substring-after(date/@rfc822, ' '), ' '), ' '), 1, 4)" />
    </xsl:variable>
    <xsl:if test="id">
      <guid>http://barbon.org/web/<xsl:value-of select="$newsyear" />/stuff.html#<xsl:value-of select="id" /></guid>
    </xsl:if>
  </item>
</xsl:template>

<!-- root template -->
<xsl:template match="/">
<rss version="2.0">
  <channel>
    <title>Stuff happens</title>
    <link>http://barbon.org/web/</link>
    <description>Assorted news items</description>
    <language>en-us</language>
    <!-- pubDate>Tue, 10 Jun 2003 04:00:00 GMT</pubDate -->
    <!-- lastBuildDate>Tue, 10 Jun 2003 09:41:01 GMT</lastBuildDate -->
    <!-- docs>http://blogs.law.harvard.edu/tech/rss</docs -->
    <generator>xsltproc</generator>
    <managingEditor>mbarbon@cpan.org</managingEditor>
    <webMaster>mbarbon@cpan.org</webMaster>

    <xsl:for-each select="/data/blob/item">
      <!-- xi:include href="sort.xsl#xmlns(xsl=http://www.w3.org/1999/XSL/Transform)xpointer(//xsl:stylesheet/xsl:sort)" / -->
<xsl:sort select="substring(substring-after(substring-after(substring-after(date/@rfc822, ' '), ' '), ' '), 1, 4)" order="descending"/>
<xsl:sort select="$vMonths/*[@name=substring(substring-after(substring-after(current()/date/@rfc822, ' '), ' '), 1, 3)]/@index"
          data-type="number"
          order="descending" />
<xsl:sort select="substring(substring-after(date/@rfc822, ' '), 1, 2)" data-type="number" order="descending" />
<xsl:sort select="substring(substring-after(substring-after(substring-after(substring-after(date/@rfc822, ' '), ' '), ' '), ' '), 1, 8)" data-type="text" order="descending" />

      <xsl:if test="position() &lt;= 5">
        <xsl:apply-templates select="." />
      </xsl:if>
    </xsl:for-each>
  </channel>
</rss>
</xsl:template>

</xsl:stylesheet>
