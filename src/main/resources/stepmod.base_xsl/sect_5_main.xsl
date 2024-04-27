<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_main.xsl,v 1.3 2003/05/04 08:15:03 robbod Exp $
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
<xsl:template match="module" mode="mim_main_module"> <!-- called from stepmod2mn.module.adoc.xsl  -->
  <xsl:call-template name="clause_header">
    <!-- <xsl:with-param name="heading" select="'5 Module interpreted model'"/> -->
    <xsl:with-param name="heading" select="'Module interpreted model'"/>
    <xsl:with-param name="aname" select="'mim'"/>
  </xsl:call-template>
  
  <!-- <h2>
    <a href="../sys/5_mapping{$FILE_EXT}#mapping">
      5.1 Mapping specification
    </a>
  </h2> -->
  <!-- 5.1 Mapping specification -->
  <xsl:apply-templates select="." mode="mapping_module"/>
  
  <xsl:if test="./mim">
    <!-- <h2>
      <a href="../sys/5_mim{$FILE_EXT}#mim_express">
        5.2 MIM EXPRESS short listing
      </a>
    </h2> -->
    <!-- 5.2 MIM EXPRESS short listing -->
    <xsl:apply-templates select="." mode="mim_module"/>
  </xsl:if>
  
</xsl:template>


</xsl:stylesheet>
