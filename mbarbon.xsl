<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  exclude-result-prefixes="xhtml"
  extension-element-prefixes="date"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:months="http://barbon.org/my/months"
  xmlns:my="http://barbon.org/my"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="sort.xsl" />

<xsl:variable name="vMonths" select="document('sort.xsl')/*/months:*"/>

<xsl:namespace-alias stylesheet-prefix="xhtml" result-prefix="#default" />

<xsl:output method="xml"
            indent="yes"
            encoding="utf-8"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

<xsl:variable name="skip-navigation" />
<xsl:variable name="body-style" />

<!-- XHTML 1.0 does not support "target" -->
<xsl:attribute-set name="a-target">
  <xsl:attribute name="onclick"
      >window.open(this.href); return false;</xsl:attribute>
</xsl:attribute-set>

<!-- pass-through xhtml:*, stripping namespace prefix -->
<xsl:template match="xhtml:*">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*" />

    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<!-- XHTML 1.0 strict does not have target attribute in <a> -->
<xsl:template match="xhtml:a">
  <xsl:choose>
    <xsl:when test="@local">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$basepath" /><xsl:value-of select="@href" /></xsl:attribute>
        <xsl:copy-of
         select="child::node()|@*[    local-name()!='href'
                                  and local-name()!='local']" />
      </a>
    </xsl:when>
    <xsl:when test="@target">
      <a xsl:use-attribute-sets="a-target"><xsl:copy-of
         select="child::node()|@*[local-name()!='target']" /></a>
    </xsl:when>
    <xsl:otherwise>
      <a><xsl:copy-of
         select="child::node()|@*[local-name()!='target']" /></a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- utility template, generate a lateral navigation link -->
<xsl:template name="item-link">
  <xsl:element name="a">
    <xsl:attribute name="href">#<xsl:choose>
        <xsl:when test="anchor">
          <xsl:value-of select="anchor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>&#8250; <xsl:value-of select="title" />
  </xsl:element>
</xsl:template>

<xsl:template match="item/anchor|subitem/anchor" />

<!-- utility template, generate a lateral navigation title with
     anchor in body -->
<xsl:template name="item-title" match="item/title">
  <h1><xsl:call-template name="item-title-href" /></h1>
</xsl:template>

<xsl:template name="subitem-title" match="subitem/title">
  <h3><xsl:call-template name="item-title-href" /></h3>
</xsl:template>

<xsl:template name="item-title-href">
  <a>
    <!-- use either anchor or title for name -->
    <xsl:attribute name="name">
      <xsl:choose>
        <xsl:when test="../anchor">
          <xsl:value-of select="../anchor" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </a>
  <xsl:value-of select="../title" />
</xsl:template>

<!-- generate links in lateral navigation bar -->
<xsl:template name="page-head-links">
  <xsl:param name="items" />

  <xsl:for-each select="$items">
    <xsl:call-template name="item-link" />
  </xsl:for-each>
</xsl:template>

<xsl:template name="project-honeypot">
  <a id="honeypot-logo" href="http://www.projecthoneypot.org?rf=46311">
    <img src="{$basepath}../mini_phpot_link.gif" height="31px" width="88px" alt="Stop Spam Harvesters, Join Project Honey Pot" />
  </a>
</xsl:template>

<!-- templates for header and footer -->
<xsl:template name="mbarbon-header">
  <div id="top"></div>

  <div id="header">
    <span class="headerRight">MSc in Computer Science<br /><a href="mailto:mattia.barbon@libero.it">mattia.barbon@libero.it</a></span>
    <span class="headerTitle">Mattia Barbon</span>

    <div class="menuBar">
      <a href="{$basepath}index.html">Home</a>|
      <a href="{$basepath}programming.html">Programming</a>|
      <a href="{$basepath}personal.html">Personal</a>
    </div>
  </div>
</xsl:template>

<xsl:template name="mbarbon-footer">
  <xsl:param name="path" select="'.'" />

  <div id="footer">
    <div class="footerLHS">
      <a href="http://validator.w3.org/check/referer">valid XHTML 1.0 Strict</a>
    </div>
    
    <div class="footerLHS">
      <a href="http://jigsaw.w3.org/css-validator/check/referer">valid CSS 2</a>
    </div>
    
    <div>
      <a href="http://barbon.org/php/slierputrid.php" style="display: none;">contact me</a>
      based upon <a href="http://www.oswd.org/viewdesign.phtml?id=1152">Blue Haze</a>
    </div>
  </div>
  <p />
</xsl:template>

<xsl:variable name="basepath" />
<xsl:variable name="itemnode" />

<!-- root template, generates header and footer -->
<xsl:template match="/">
<html xml:lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="author" content="haran" />
    <meta name="generator" content="GNU Emacs &amp; xsltproc" />
    <meta name="description" content="Mattia Barbon home page" />
    <meta name="keywords" content="Mattia Barbon home page" />
    <meta name="verify-v1" content="DB9W6kq1fB+DDEO3OV2hrHbQGrYcXSSs/Xg+oEAN5Xo=" />
    <link rel="stylesheet" type="text/css" href="{$basepath}css/bluehaze-mobile.css" title="Blue Haze stylesheet" media="handheld" />
    <link rel="stylesheet" type="text/css" href="{$basepath}css/bluehaze.css" title="Blue Haze stylesheet" media="tv,projection,print,screen" />
    <link rel="stylesheet" type="text/css" href="{$basepath}css/color-scheme.css" title="Blue Haze stylesheet" media="all" />
    <link href="{$basepath}stuff.rss" rel="alternate"
          type="application/rss+xml" title="Stuff happens" />
    <link href="{$basepath}perl.rss" rel="alternate"
          type="application/rss+xml" title="Stuff happens (Perl)" />
    <title>Mattia Barbon</title>
  </head>

  <body>  
    <!-- ###### Header ###### -->
    <xsl:call-template name="mbarbon-header" />

    <!-- ###### Side Boxes ###### -->

    <xsl:if test="not(boolean($skip-navigation))">
      <div class="sideBox LHS">
        <div id="this-page">This Page</div>
          <xsl:call-template name="lateral-menu" />
      </div>
    </xsl:if>

    <!-- ###### Body Text ###### -->
    <div id="content" style="{$body-style}">
      <xsl:apply-templates />
    </div>
    
    <!-- ###### Footer ###### -->
    <xsl:call-template name="mbarbon-footer" />

  </body>
</html>
</xsl:template>

<!-- list of links -->
<xsl:template match="links/link">
  <xsl:choose>
    <xsl:when test="external">
      <a xsl:use-attribute-sets="a-target" href="{url}"><xsl:value-of select="text" /></a>
    </xsl:when>
    <xsl:otherwise>
      <a href="{url}"><xsl:value-of select="text" /></a>
    </xsl:otherwise>
  </xsl:choose>
  <br />
</xsl:template>

<!-- date -->
<xsl:template name="date">
  <xsl:value-of select="0 + my:day-rfc822(date)" />
  <xsl:value-of select="' '" />
  <xsl:value-of select="my:longmonth-rfc822(date)" />
  <xsl:value-of select="' '" />
  <xsl:value-of select="my:year-rfc822(date)" />
</xsl:template>

<!-- list item -->
<xsl:template match="item|subitem">
  <xsl:apply-templates />
</xsl:template>

<!-- news item -->
<xsl:template name="news-item">
  <dt>
    <xsl:if test="id">
      <a>
        <xsl:attribute name="name"><xsl:copy-of select="id" /></xsl:attribute>
      </a>
    </xsl:if>
    <xsl:call-template name="date" select="date" />
    <xsl:if test="title">
      - <xsl:value-of select="title" />
    </xsl:if>
  </dt> 
  <dd>
    <xsl:choose>
      <xsl:when test="content"><xsl:apply-templates select="content" /></xsl:when>
      <xsl:otherwise><xsl:apply-templates select="description" /></xsl:otherwise>
    </xsl:choose>
  </dd>
</xsl:template>

<!-- insert full news list -->
<xsl:template match="news-items">
  <dl>
    <!-- use either the year attribute in news-items or the command-line
         parameter -->
    <xsl:variable name="year">
      <xsl:choose>
        <xsl:when test="@year"><xsl:value-of select="@year" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="$year" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="count"><xsl:value-of select="@count" /></xsl:variable>
    <xsl:for-each select="/data/blob/item">
      <xsl:sort select="my:date-rfc822(date)" order="descending" />
      <xsl:if test="position() &lt;= $count and $year = my:year-rfc822(date/@rfc822)">
        <xsl:call-template name="news-item" />
      </xsl:if>
    </xsl:for-each>
  </dl>
</xsl:template>

<!-- short news item -->
<xsl:template name="short-news-item">
  <li>
    <xsl:call-template name="date" select="date" />:
    <xsl:apply-templates select="description" />
    <xsl:if test="id">
      <a>
        <xsl:attribute name="href"><xsl:value-of select="$basepath" /><xsl:value-of select="my:year-rfc822(date/@rfc822)" />/stuff.html#<xsl:copy-of select="id" /></xsl:attribute>
        More...
      </a>
    </xsl:if>
  </li>
</xsl:template>

<!-- insert short news list -->
<xsl:template match="short-news-items">
  <ul>
    <xsl:variable name="count"><xsl:value-of select="@count" /></xsl:variable>
    <xsl:for-each select="/data/blob/item">
      <xsl:sort select="my:date-rfc822(date)" order="descending" />
      <xsl:if test="position() &lt;= $count">
        <xsl:call-template name="short-news-item" />
      </xsl:if>
    </xsl:for-each>
  </ul>
</xsl:template>

<!-- insert book list -->
<xsl:template match="book-items">
  <h3><xsl:value-of select="@title" /></h3>
  <xsl:variable name="year">
    <xsl:value-of select="@read_in" />
  </xsl:variable>
  <ul>
    <xsl:apply-templates select="/data/books/book[@read = $year]" />
  </ul>
</xsl:template>

<!-- book -->
<xsl:template match="books/book">
  <li>
    &quot;<xsl:value-of select="@title" />&quot;,
          <xsl:value-of select="@author" />
  </li>
</xsl:template>

<!-- do not automatically process all items -->
<xsl:template match="/data/" />

</xsl:stylesheet>
