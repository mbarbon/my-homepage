<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  exclude-result-prefixes="xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="mbarbon.xsl" />

<xsl:template name="lateral-menu">
  <xsl:call-template name="page-head-links">
    <xsl:with-param name="items" select="/data/programming/item" />
  </xsl:call-template>
  <xsl:call-template name="project-honeypot" />
</xsl:template>

<xsl:template match="/data/programming">
  <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>
