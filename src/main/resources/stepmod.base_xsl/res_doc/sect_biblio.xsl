<?xml version="1.0" encoding="utf-8"?>

<!--
$Id: sect_biblio.xsl,v 1.2 2002/12/19 21:02:58 nigelshaw Exp $
  Original Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display of bibliography
  	Adapted to work with resource documents by Tom Hendrix and Nigel Shaw
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--  <xsl:import href="resource.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
<!--  <xsl:import href="resource_clause.xsl"/> -->

<!--  <xsl:import href="../projmg/issues.xsl"/> -->

<!--  <xsl:output method="html"/> -->

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource" mode="bibliography">
  <!-- <div align="left">
    <h2>
      <A NAME="bibliography">Bibliography</A>
    </h2>
  </div> -->
  <xsl:text>[bibliography]</xsl:text>
	<xsl:text>&#xa;</xsl:text>
	<xsl:call-template name="insertHeaderADOC">
		<!-- <xsl:with-param name="id" select="'bibliography'"/>		 -->
		<xsl:with-param name="level" select="1"/>
		<xsl:with-param name="header" select="'Bibliography'"/>		
	</xsl:call-template>
	
  <!-- output any issues -->
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'bibliography'"/>
  </xsl:apply-templates>


  <xsl:choose>
    <xsl:when test="./bibliography">
      <xsl:apply-templates select="./bibliography"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- output the defaults -->
      <!-- but the default is for modules so commented out -->
<!--      
      <xsl:apply-templates 
        select="document('../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>      
-->
    </xsl:otherwise>
  </xsl:choose>

	<!-- https://github.com/metanorma/stepmod2mn/issues/32#issuecomment-1556860065 -->
	<!-- Example:
	* [[[action_schema.exp,repo:(current-metanorma-collection/action_schema.exp)]]]
	* [[[action_schema.htm,repo:(current-metanorma-collection/action_schema.htm)]]]
	-->
	<xsl:for-each select="./schema">
		<xsl:text>* [[[</xsl:text><xsl:value-of select="@name"/><xsl:text></xsl:text>.exp,repo:(current-metanorma-collection/<xsl:value-of select="@name"/><xsl:text>.exp)]]]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>
	<xsl:for-each select="./schema">
		<xsl:text>* [[[</xsl:text><xsl:value-of select="@name"/><xsl:text></xsl:text>.htm,repo:(current-metanorma-collection/<xsl:value-of select="@name"/><xsl:text>.htm)]]]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:for-each>
	<xsl:text>&#xa;</xsl:text>

</xsl:template>
  
</xsl:stylesheet>
