<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?> -->

<!--
$Id: sect_b_obj_reg.xsl,v 1.13 2006/11/09 14:28:50 darla Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

 <!--   <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
 <!-- <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/> -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="annex_b"> <!-- called from stepmod2mn.module.adoc.xsl  -->
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'B'"/>
    <xsl:with-param name="heading" 
      select="'Information object registration'"/>
    <xsl:with-param name="aname" select="'annexb'"/>
    <xsl:with-param name="informative" select="'normative'"/>
  </xsl:call-template>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ_</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
  
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml"
    select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="arm_xml_document" select="document($arm_xml)"/>

  <xsl:variable name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>
  <xsl:variable name="mim_xml_document" select="document($mim_xml)"/>

  <!-- there is only one schema in a module -->
  <xsl:variable 
    name="schema_name" 
    select="$arm_xml_document/express/schema/@name"/>

  <xsl:variable
    name="object_reg" 
    select="concat('{ iso standard 10303 part(',@part,') version(',@version,')')"/>
    
  <xsl:variable name="inf_obj_annex_letter">
    <xsl:choose>
      <xsl:when test="./mim">B</xsl:when>
      <xsl:otherwise>A</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="inf_obj_arm_lf_number">
    <xsl:choose>
      <xsl:when test="./mim">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- <h2>
    <a name="b1">
      <xsl:value-of select="$inf_obj_annex_letter"/> Document identification
    </a>
  </h2> -->
  <xsl:call-template name="insertHeaderADOC">
    <xsl:with-param name="id" select="'b1'"/>		
    <xsl:with-param name="level" select="2"/>
    <xsl:with-param name="header" select="'Document Identification'"/>					
  </xsl:call-template>
  
  <!-- <p> -->
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    To provide for unambiguous identification of an information object in an
    open system, the object identifier
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->
  
  <!-- <p align="center"> -->
  <xsl:text>[align=center]</xsl:text>
  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    <xsl:value-of 
      select="concat($object_reg,' }' )"/>
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->
  <!-- <p> -->
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    is assigned to this document. The meaning of this value is defined
    in ISO/IEC 8824-1, and is described in ISO 10303-1.  
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->

  <!-- <h2>
    <a name="b2">
      <xsl:value-of select="$inf_obj_annex_letter"/>.2 Schema identification
    </a>
  </h2> -->
  <xsl:call-template name="insertHeaderADOC">
    <xsl:with-param name="id" select="'b2'"/>
    <xsl:with-param name="level" select="2"/>
    <xsl:with-param name="header" select="'Schema identification'"/>					
  </xsl:call-template>
  
  <!-- get the name of the ARM schema from the express -->
  <xsl:variable name="arm_schema" 
    select="$arm_xml_document/express/schema/@name"/>
  <xsl:variable name="arm_schema_reg" 
    select="translate($arm_schema,$UPPER, $LOWER)"/>


  <!-- <h2>
    <a name="b21">
      <xsl:value-of select="$inf_obj_annex_letter"/>.2.1 <xsl:value-of select="$arm_schema"/> schema identification
    </a>
  </h2> -->
  <xsl:call-template name="insertHeaderADOC">
    <xsl:with-param name="id" select="'b21'"/>
    <xsl:with-param name="level" select="3"/>
    <xsl:with-param name="header"><xsl:value-of select="$arm_schema"/> schema identification</xsl:with-param>
  </xsl:call-template>

  <!--<p> -->
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    To provide for unambiguous identification of the schema specifications
    given in this application module in an open information system, the object
    identifiers are assigned as follows: 
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->
  
  <!-- <p align="center"> -->
  <xsl:text>[align=center]</xsl:text>
  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    <xsl:value-of 
      select="concat($object_reg,' schema(1) ', $arm_schema_reg,'(1) }' )"/>
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->
  
  <!-- <p> -->
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    is assigned to the <xsl:value-of select="$arm_schema"/> schema. 
    The meaning of this value is defined in ISO/IEC 8824-1, and is described in
    ISO 10303-1.  
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->

  <xsl:if test="./mim">
    <!-- get the name of the MIM schema from the express -->
    <xsl:variable name="mim_schema" 
      select="$mim_xml_document/express/schema/@name"/>
    <xsl:variable name="mim_schema_reg" 
      select="translate($mim_schema,$UPPER, $LOWER)"/>

    <!-- <h2>
      <a name="b22">
        <xsl:value-of select="$inf_obj_annex_letter"/>.2.2 <xsl:value-of select="$mim_schema"/> schema identification
      </a>
    </h2> -->
    <xsl:call-template name="insertHeaderADOC">
      <xsl:with-param name="id" select="'b22'"/>
      <xsl:with-param name="level" select="3"/>
      <xsl:with-param name="header"><xsl:value-of select="$mim_schema"/> schema identification</xsl:with-param>
    </xsl:call-template>

    <!-- <p> -->
    <xsl:call-template name="insertParagraph">
      <xsl:with-param name="text">
      To provide for unambiguous identification of the schema specifications
      given in this application module in an open information system, the object
      identifiers are assigned as follows: 
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    
    <!-- <p align="center"> -->
    <xsl:text>[align=center]</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:call-template name="insertParagraph">
      <xsl:with-param name="text">
      <xsl:value-of 
        select="concat($object_reg,' schema(1) ', $mim_schema_reg,'(2) }' )"/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    
    <!-- <p> -->
    <xsl:call-template name="insertParagraph">
      <xsl:with-param name="text">
      is assigned to the <xsl:value-of select="$mim_schema"/> schema. 
      The meaning of this value is defined in ISO/IEC 8824-1, and is described in
      ISO 10303-1.  
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
  </xsl:if>


  <xsl:if test="./arm_lf">
    <!-- get the name of the ARM_LF schema from the express -->
    <xsl:variable name="arm_lf_xml"
      select="concat($module_dir,'/arm_lf.xml')"/>
    <xsl:variable name="arm_lf_xml_document" select="document($arm_lf_xml)"/>
    <xsl:variable name="arm_schema_lf" 
      select="$arm_lf_xml_document/express/schema/@name"/>
    <xsl:variable name="arm_schema_lf_reg" 
      select="translate($arm_schema_lf,$UPPER, $LOWER)"/>
    

    <!-- <h2>
      <a name="b23">
        <xsl:value-of select="$inf_obj_annex_letter"/>.2.<xsl:value-of select="$inf_obj_arm_lf_number"/> <xsl:value-of select="$arm_schema_lf"/> schema identification
      </a>
    </h2> -->
    <xsl:call-template name="insertHeaderADOC">
      <xsl:with-param name="id" select="'b23'"/>
      <xsl:with-param name="level" select="3"/>
      <xsl:with-param name="header"><xsl:value-of select="$arm_schema_lf"/> schema identification</xsl:with-param>
    </xsl:call-template>

    <!-- <p> -->
    <xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
      To provide for unambiguous identification of the schema specifications
      given in this application module in an open information system, the object
      identifiers are assigned as follows: 
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    
    <!-- <p align="center"> -->
    <xsl:text>[align=center]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
      <xsl:value-of 
        select="concat($object_reg,' schema(1) ', $arm_schema_lf_reg,'(',$inf_obj_arm_lf_number,') }' )"/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    <!-- <p> -->
    <xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
      is assigned to the <xsl:value-of select="$arm_schema_lf"/> schema. 
      The meaning of this value is defined in ISO/IEC 8824-1, and is described in
      ISO 10303-1.
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
  </xsl:if>

  <xsl:if test="./mim_lf">
    <!-- get the name of the MIM_LF schema from the express -->
    <xsl:variable name="mim_lf_xml"
      select="concat($module_dir,'/mim_lf.xml')"/>
    <xsl:variable name="mim_lf_xml_document" select="document($mim_lf_xml)"/>
    <xsl:variable name="mim_schema_lf" 
      select="$mim_lf_xml_document/express/schema/@name"/>
    <xsl:variable name="mim_schema_lf_reg" 
      select="translate($mim_schema_lf,$UPPER, $LOWER)"/>
    
    <!-- <h2>
      <a name="b24">
       <xsl:value-of select="$inf_obj_annex_letter"/>.2.4 <xsl:value-of select="$mim_schema_lf"/> schema identification
     </a>
    </h2> -->
    <xsl:call-template name="insertHeaderADOC">
      <xsl:with-param name="id" select="'b24'"/>
      <xsl:with-param name="level" select="3"/>
      <xsl:with-param name="header"><xsl:value-of select="$mim_schema_lf"/> schema identification</xsl:with-param>
    </xsl:call-template>

    <!-- <p> -->
    <xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
      To provide for unambiguous identification of the schema specifications
      given in this application module in an open information system, the object
      identifiers are assigned as follows: 
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    <!-- <p align="center"> -->
    <xsl:text>[align=center]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
      <xsl:value-of 
        select="concat($object_reg,' schema(1) ', $mim_schema_lf_reg,'(4) }' )"/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    <!-- <p> -->
    <xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
      is assigned to the <xsl:value-of select="$mim_schema_lf"/> schema. 
      The meaning of this value is defined in ISO/IEC 8824-1, and is described in
      ISO 10303-1.
      </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
  </xsl:if>
</xsl:template>
  
</xsl:stylesheet>
