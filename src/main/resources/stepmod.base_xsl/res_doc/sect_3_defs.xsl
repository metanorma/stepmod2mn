<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_3_defs.xsl,v 1.5 2009/12/24 17:42:04 lothartklein Exp $
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
<!--   <xsl:import href="resource_clause.xsl"/> -->


  <xsl:output method="html"/>

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource" mode="terms_definitions_resource">
  <!-- Output the terms identified in the normative references -->
  <!-- <h2 level="1">
    <a name="defns"> -->
      <!--
      <xsl:choose>
        <xsl:when test="./definition/term">
          3 Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise>
          3 Terms and abbreviations
        </xsl:otherwise>
      </xsl:choose>
-->
      <!-- <xsl:choose>
        <xsl:when test="./abbreviation">
          Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise> -->
          <!-- every module references Terms defined in other standards,
               and abbreviations hence as per ISO -->
         <!--  Terms, definitions and abbreviated terms
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </h2> -->
	
	<xsl:variable name="header">Terms, definitions and abbreviated terms</xsl:variable>
		
	<xsl:text>&#xa;</xsl:text>
	<xsl:call-template name="insertHeaderADOC">
		<xsl:with-param name="id" select="'defns'"/>		
		<xsl:with-param name="level" select="1"/>
		<xsl:with-param name="header" select="$header"/>					
	</xsl:call-template>
	
    <!-- <h2 level="2">
      <a name="termsdefns">
        Terms and definitions
      </a>        
    </h2>   -->
	
	<!-- <xsl:call-template name="insertHeaderADOC">
		<xsl:with-param name="id" select="'termsdefns'"/>		
		<xsl:with-param name="level" select="2"/>
		<xsl:with-param name="header" select="'Terms and definitions'"/>					
	</xsl:call-template> -->	
		
  <xsl:call-template name="output_terms">
    <xsl:with-param name="current_resource" select="."/>
    <xsl:with-param name="resource_number" select="./@part"/>
  </xsl:call-template>
</xsl:template>
  
</xsl:stylesheet>
