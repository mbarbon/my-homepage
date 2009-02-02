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
    <xsl:with-param name="items" select="/data/*[name() = $itemnode]/item" />
  </xsl:call-template>
  <xsl:call-template name="project-honeypot" />
</xsl:template>

<xsl:template match="/data/*">
  <xsl:if test="name() = $itemnode">
    <xsl:apply-templates />
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
