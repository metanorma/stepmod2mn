<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_introduction.xsl,v 1.3 2002/03/04 07:50:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output introduction as a web page
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan" 
	exclude-result-prefixes="xalan"
                version="1.0">

<!--   <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
<!--   <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/> -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="introduction"> <!-- called from stepmod2mn.module.adoc.xsl  -->
  <xsl:apply-templates select="purpose"/>
</xsl:template>
  
</xsl:stylesheet>
