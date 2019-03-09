<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<xsl:template match="/">
<xsl:for-each select="/CatapultToc/TocEntry">
- label: <xsl:value-of select="@Title"/>
  url: <xsl:value-of select="@Link"/>
  children:
  <xsl:for-each select="TocEntry">
  - label: <xsl:value-of select="@Title"/>
    url: <xsl:value-of select="@Link"/>
  <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>