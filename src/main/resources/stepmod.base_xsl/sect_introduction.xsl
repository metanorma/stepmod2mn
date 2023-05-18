<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_introduction.xsl,v 1.2 2002/01/15 10:18:15 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output introduction as a web page
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan" 
                version="1.0">

<!--   <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
<!--   <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/> -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="introduction">
  <xsl:apply-templates select="purpose"/>
</xsl:template>
  
</xsl:stylesheet>
