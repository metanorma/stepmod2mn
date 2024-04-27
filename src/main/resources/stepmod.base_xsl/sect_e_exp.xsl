<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_e_exp.xsl,v 1.3 2003/05/29 15:26:39 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <!-- <xsl:import href="module_clause.xsl"/> -->


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="annex_e"> <!-- called from stepmod2mn.module.adoc.xsl  -->
  <xsl:variable name="comp_int_annex_letter">
    <xsl:choose>
      <xsl:when test="./mim">E</xsl:when>
      <xsl:otherwise>C</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$comp_int_annex_letter"/>
    <xsl:with-param name="heading" 
      select="'Computer interpretable listings'"/>
    <xsl:with-param name="aname" select="'annexe'"/>
  </xsl:call-template>

  <xsl:apply-templates select="." mode="annexe"/>
</xsl:template>
  
</xsl:stylesheet>
