<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  extension-element-prefixes="exsl-common"
  exclude-result-prefixes="xhtml"
  xmlns:exsl-common="http://exslt.org/common"
  xmlns:months="http://barbon.org/my/months"
  xmlns:my="http://barbon.org/my"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="sort.xsl" />

<xsl:variable name="vMonths" select="document('sort.xsl')/*/months:*"/>

<xsl:param name="tag" />
<xsl:variable name="vItems">
<xsl:choose>
  <xsl:when test="$tag != 'all'">
    <xsl:copy-of select="/data/blob/item[tag/@name=$tag]" />
  </xsl:when>
  <xsl:otherwise>
    <xsl:copy-of select="/data/blob/item" />
  </xsl:otherwise>
</xsl:choose>
</xsl:variable>

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
    <xsl:if test="id">
      <guid>http://barbon.org/web/<xsl:value-of select="my:year-rfc822(date/@rfc822)" />/stuff.html#<xsl:value-of select="id" /></guid>
    </xsl:if>
  </item>
</xsl:template>

<!-- root template -->
<xsl:template match="/">
<rss version="2.0">
  <channel>
    <title>Stuff happens</title>
    <link>http://barbon.org/web/all_news.html</link>
    <description>Assorted news items</description>
    <language>en-us</language>
    <!-- pubDate>Tue, 10 Jun 2003 04:00:00 GMT</pubDate -->
    <!-- lastBuildDate>Tue, 10 Jun 2003 09:41:01 GMT</lastBuildDate -->
    <!-- docs>http://blogs.law.harvard.edu/tech/rss</docs -->
    <generator>xsltproc</generator>
    <managingEditor>mbarbon@cpan.org</managingEditor>
    <webMaster>mbarbon@cpan.org</webMaster>

    <xsl:for-each select="exsl-common:node-set($vItems)/item">
      <xsl:sort select="my:date-rfc822(date)" order="descending" />
      <xsl:if test="position() &lt;= 5">
        <xsl:apply-templates select="." />
      </xsl:if>
    </xsl:for-each>
  </channel>
</rss>
</xsl:template>

</xsl:stylesheet>
