<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_3_defs.xsl,v 1.10 2009/12/24 17:42:03 lothartklein Exp $
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


  <!-- <xsl:output method="html"/> -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="terms_definitions_module">
  <!-- Output the terms identified in the normative references -->
  <!--
       ISO requested:
       - If clause 3 only contains terms and definitions, the title of the
         clause shall be "Terms and definitions". 

       - If clause 3 only contains terms, definitions, and abbreviations,
         the title of the clause shall be "Terms, definitions, and abbreviations". 

       - If clause 3 only contains terms, definitions, and symbols, the
          title of the clause shall be "Terms, definitions, and symbols". 

       - If clause 3 contains terms, definitions, abbreviations, and
         symbols, the title of the clause shall be "Terms, definitions,
         abbreviations, and symbols".  
       -->
  <!-- <h2>
    <a name="defns">
      <xsl:choose>
        <xsl:when test="./definition/term">
          3 Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise> -->
          <!-- every module references Terms defined in other standards,
               and abbreviations hence as per ISO -->
  <!--        3 Terms, definitions and abbreviated terms
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </h2> -->
  
  <xsl:text>&#xa;</xsl:text>
	<xsl:call-template name="insertHeaderADOC">
		<xsl:with-param name="id" select="'defns'"/>		
		<xsl:with-param name="level" select="1"/>
		<xsl:with-param name="header">Terms, definitions and abbreviated terms</xsl:with-param>
	</xsl:call-template>
  
    <!-- <h2>
      <a name="termsdefns">
        3.1 Terms and definitions
      </a>        
    </h2> -->
    
    <xsl:call-template name="insertHeaderADOC">
      <xsl:with-param name="id" select="'termsdefns'"/>		
      <xsl:with-param name="level" select="2"/>
      <xsl:with-param name="header" select="'Terms and definitions'"/>					
    </xsl:call-template>
    
  <xsl:call-template name="output_terms">
    <xsl:with-param name="module_number" select="./@part"/>
  </xsl:call-template>
</xsl:template>
  
</xsl:stylesheet>
