<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  exclude-result-prefixes="xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            indent="yes"
            encoding="utf-8"
            />

<xsl:template name="fxm">
  <a href="#news">&#8250; News</a>
</xsl:template>

<!-- pass-through xhtml:*, stripping all tags -->
<xsl:template match="xhtml:*">
  <xsl:apply-templates />
</xsl:template>

<!-- news item -->
<xsl:template match="item">
  <item>
    <title><xsl:apply-templates select="title" /></title>
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
    <guid>http://wxperl.eu/news.html#<xsl:value-of select="id" /></guid>

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

    <xsl:apply-templates select="/data/blob/item[position() &lt; 10]"/>
  </channel>
</rss>
</xsl:template>

</xsl:stylesheet>
