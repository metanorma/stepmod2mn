<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_main.xsl,v 1.2 2003/03/13 19:17:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to PLCS under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--   <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <!-- <xsl:import href="module_clause.xsl"/> -->

  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="mim_main_module">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'5 Module interpreted model'"/>
    <xsl:with-param name="aname" select="'mim'"/>
  </xsl:call-template>
  
  <!-- <h2>
    <a href="../sys/5_mapping{$FILE_EXT}#mapping">
      5.1 Mapping specification
    </a>
  </h2> -->
  <!-- 5.1 Mapping specification -->
  <xsl:apply-template select="." mode="mapping_module"/>
  
  <!-- <h2>
    <a href="../sys/5_mim{$FILE_EXT}#mim_express">
      5.2 MIM EXPRESS short listing
    </a>
  </h2> -->
  <!-- 5.2 MIM EXPRESS short listing -->
  <xsl:apply-template select="." mode="mim_module"/>
  
</xsl:template>


</xsl:stylesheet>
