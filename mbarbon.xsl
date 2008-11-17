<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  exclude-result-prefixes="xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
  <xhtml:a href="http://www.projecthoneypot.org?rf=46311">
    <xhtml:img src="/mini_phpot_link.gif" height="31px" width="88px" alt="Stop Spam Harvesters, Join Project Honey Pot" />
  </xhtml:a>
</xsl:template>

<!-- templates for header and footer -->
<xsl:template name="wxperl-header">
  <xsl:param name="path" select="'.'" />

  <div id="top"></div>

  <div id="header">
    <span class="headerRight">MSc in Computer Science<br /><a href="mailto:mattia.barbon@libero.it">mattia.barbon@libero.it</a></span>
    <span class="headerTitle">Mattia Barbon</span>

    <div class="menuBar">
      <a href="{$path}/index.html">Home</a>|
      <a href="{$path}/programming.html">Programming</a>|
      <a href="{$path}/personal.html">Personal</a>
    </div>
  </div>
</xsl:template>

<xsl:template name="wxperl-footer">
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

<!-- root template, generates header and footer -->
<xsl:template match="/">
<html xml:lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="author" content="haran" />
    <meta name="generator" content="GNU Emacs" />
    <link rel="stylesheet" type="text/css" href="css/bluehaze.css" title="Blue Haze stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/color-scheme.css" title="Blue Haze stylesheet" />
    <link rel="shortcut icon" href="favicon.ico" type="text/css" />
    <link href="http://wxperl.eu/wxperl.rss" rel="alternate"
          type="application/rss+xml" title="wxPerl news" />
    <title>Mattia Barbon</title>
  </head>

  <body>  
    <!-- ###### Header ###### -->
    <xsl:call-template name="wxperl-header" />

    <!-- ###### Side Boxes ###### -->

    <xsl:if test="not(boolean($skip-navigation))">
      <div class="sideBox LHS">
        <div>This Page</div>
          <xsl:call-template name="lateral-menu" />
      </div>
    </xsl:if>

    <!-- ###### Body Text ###### -->
    <div id="content" style="{$body-style}">
      <xsl:apply-templates />
    </div>
    
    <!-- ###### Footer ###### -->
    <xsl:call-template name="wxperl-footer" />

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

<!-- list item -->
<xsl:template match="item|subitem">
  <xsl:apply-templates />
</xsl:template>

<!-- news item -->
<xsl:template match="news/item">
  <dt>
    <xsl:if test="id">
      <a>
        <xsl:attribute name="name"><xsl:copy-of select="id" /></xsl:attribute>
      </a>
    </xsl:if>
  <xsl:value-of select="date" /></dt> 
  <dd><xsl:apply-templates select="content" /></dd>
</xsl:template>

<!-- short news item -->
<xsl:template match="short-news/item">
  <li>
    <xsl:if test="id">
      <a>
        <xsl:attribute name="name"><xsl:copy-of select="id" /></xsl:attribute>
      </a>
    </xsl:if>
  <xsl:value-of select="date" />:
  <xsl:apply-templates select="content" /></li>
</xsl:template>

<!-- insert short news list -->
<xsl:template match="short-news-items">
  <ul>
    <xsl:apply-templates select="/data/short-news/item" />
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
