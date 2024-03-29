<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_1_scope.xsl,v 1.6 2003/07/15 14:02:51 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the Scope section as a web page
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xalan/java" 
                version="1.0">

<!--   <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <!-- <xsl:import href="module_clause.xsl"/> -->


  <!-- <xsl:output method="html"/> -->


<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="scope_module">
  <!-- <xsl:apply-templates select="." mode="special_header"/>
  <h1>
    Industrial automation systems and integration &#8212; <br/>
    Product data representation and exchange &#8212;  <br/>
    Part <xsl:value-of select="@part"/>:<br/>
    Application module: 
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </h1> -->
  
  <xsl:apply-templates select="./inscope"/>
  <xsl:apply-templates select="./outscope"/>
</xsl:template>
  

<!-- <xsl:template match="module" mode="special_header">
  <xsl:variable name="right">
    <xsl:choose>
      <xsl:when test="@status='WD' or @status='CD' or @status='DIS'">
        <xsl:value-of select="concat('ISO','/',@status,' 10303-',@part)"/>
      </xsl:when>
      <xsl:when test="@status='CD-TS'">
        <xsl:value-of select="concat('ISO/CD TS 10303-',@part)"/>
      </xsl:when>
      <xsl:when test="@status='IS'">
        <xsl:value-of select="concat('ISO',' 10303-',@part,':',@publication.year,'(',@language,')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('ISO','/',@status,' 10303-',@part,':',@publication.year,'(',@language,')')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="left">
    <xsl:choose>
      <xsl:when test="@status='WD'"> 
        <xsl:value-of select="'WORKING DRAFT'"/>
      </xsl:when>
      <xsl:when test="@status='CD' or @status='CD-TS'">
        <xsl:value-of select="'COMMITTEE DRAFT'"/>
      </xsl:when>
      <xsl:when test="@status='DIS'">
        <xsl:value-of select="'DRAFT INTERNATIONAL STANDARD'"/>
      </xsl:when>
      <xsl:when test="@status='FDIS'">
        <xsl:value-of select="'FINAL DRAFT INTERNATIONAL STANDARD'"/>
      </xsl:when>
      <xsl:when test="@status='IS'">
        <xsl:value-of select="'INTERNATIONAL STANDARD'"/>
      </xsl:when>
      <xsl:when test="@status='TS'">
        <xsl:value-of select="'TECHNICAL SPECIFICATION'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <p/>
  <hr/>
  <table width="100%">
    <tr>
      <td align="left">
        <xsl:value-of select="$left"/>
      </td>
      <td align="right">
        <xsl:value-of select="$right"/>
      </td>
    </tr>
  </table>
  <hr/>
</xsl:template>
-->

	<xsl:template match="module" mode="docnumber">
		<xsl:choose>
			<xsl:when test="@status='WD' or @status='CD' or @status='DIS'">
				<xsl:value-of select="concat('ISO/',@status,' 10303-',@part)"/>
			</xsl:when>
			<xsl:when test="@status='CD-TS'">
				<xsl:value-of select="concat('ISO/CD TS 10303-',@part)"/>
			</xsl:when>
			<xsl:when test="@status='IS'">
				<xsl:value-of select="concat('ISO',' 10303-',@part,':',@publication.year,'(',@language,')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('ISO/',@status,' 10303-',@part,':',@publication.year,'(',@language,')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="module" mode="docstage">
		<xsl:choose>
			<xsl:when test="@status='WD'"> <!-- WORKING DRAFT -->
				<xsl:text>:docstage: 20</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='CD' or @status='CD-TS'"> <!-- COMMITTEE DRAFT -->
				<xsl:text>:docstage: 30</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='DIS'"> <!-- DRAFT INTERNATIONAL STANDARD -->
				<xsl:text>:docstage: 40</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='FDIS'"> <!-- FINAL DRAFT INTERNATIONAL STANDARD -->
				<xsl:text>:docstage: 50</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='IS'"> <!-- INTERNATIONAL STANDARD -->
				<xsl:text>:docstage: 60</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 60</xsl:text>        
			</xsl:when>
			<xsl:when test="@status='TS'"> <!-- TECHNICAL SPECIFICATION -->
				<xsl:text>:docstage: 30</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>        
			</xsl:when>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
