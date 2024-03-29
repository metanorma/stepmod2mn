<?xml version="1.0" encoding="utf-8"?>

<!--
$Id: sect_e_examples.xsl,v 1.2 2002/12/20 12:35:58 nigelshaw Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--   <xsl:import href="resource.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
<!--  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/> -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="resource" mode="examples">

   <xsl:variable name="annex_list">
     <xsl:apply-templates select="." mode="annex_list" />
   </xsl:variable>

  <xsl:variable name="pos" >
	<xsl:call-template name="annex_position" >
		<xsl:with-param name="annex_name" select="'Examples'"/>
		<xsl:with-param name="annex_list" select="$annex_list" />
	</xsl:call-template>
  </xsl:variable>

  <xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />

  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="heading" select="'Examples'"/>
    <xsl:with-param name="aname" select="'examples'"/>
  </xsl:call-template>

  <xsl:apply-templates select="examples"/>
</xsl:template>

</xsl:stylesheet>
