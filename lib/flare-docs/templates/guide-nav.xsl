<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />
  
  <xsl:template match="/">
<xsl:apply-templates select="/TocEntry"/>
  </xsl:template>

    <xsl:template match="/TocEntry">
label: <xsl:value-of select="@Title" />
pages:
<xsl:apply-templates />
  </xsl:template>

  <xsl:template match="TocEntry[TocEntry]">
    label: <xsl:value-of select="@Title" />
    url: <xsl:value-of select="@Link" />
    children:
      <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="TocEntry[not(TocEntry)]">
    label: <xsl:value-of select="@Title" />
    url: <xsl:value-of select="@Link" />
      <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>