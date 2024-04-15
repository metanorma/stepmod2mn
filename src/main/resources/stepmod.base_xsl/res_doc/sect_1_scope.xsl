<?xml version="1.0" encoding="utf-8"?>

<!--
$Id: sect_1_scope.xsl,v 1.6 2008/12/16 15:44:48 darla Exp $
	Purpose: Output the Scope section as a web page
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xalan/java" 
								version="1.0">

<!-- <xsl:import href="resource.xsl"/>
<xsl:import href="resource_clause.xsl"/> -->
<!-- <xsl:output method="html"/> -->

	<!-- overwrites the template declared in resource.xsl -->
	<xsl:template match="resource" mode="scope_resource">
	<!--  <xsl:apply-templates select="." mode="special_header"/>
		<h1>
			Industrial automation systems and integration &#8212; <br/>
			Product data representation and exchange &#8212;  <br/>
			Part <xsl:value-of select="@part"/>:<br/>
		<xsl:apply-templates select="." mode="type"/>: 
			<xsl:call-template name="res_display_name">
				<xsl:with-param name="res" select="@name"/>
			</xsl:call-template>
		</h1> -->
		<xsl:apply-templates select="." mode="scope_header"/>	
		
		<xsl:variable name="scope">
			<xsl:apply-templates select="./scope"/>
		</xsl:variable>
		<xsl:copy-of select="$scope"/>
		<xsl:if test="not(java:endsWith(java:java.lang.String.new($scope),'&#xa;') or java:endsWith(java:java.lang.String.new($scope),'&#xd;'))">
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
			
		<xsl:apply-templates select="./inscope"/>
		<xsl:apply-templates select="./outscope"/>
	</xsl:template>

	<xsl:template match="scope/ul/li[*[1][local-name() = 'b' or local-name() = 'b2']]" priority="2">
		<xsl:apply-templates /> <!-- skip list creation * -->
	</xsl:template>
	<xsl:template match="scope/ul/li/*[1][local-name() = 'b' or local-name() = 'b2']" priority="2">
		<xsl:call-template name="insertHeaderADOC">
			<xsl:with-param name="level" select="2"/>
			<xsl:with-param name="header"><xsl:apply-templates /></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="resource" mode="scope_header">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'Scope'"/> <!-- 1 Scope -->
			<xsl:with-param name="aname" select="'scope'"/>
		</xsl:call-template>
		
		<xsl:call-template name="insertHeaderADOC">
			<xsl:with-param name="level" select="2"/>
			<xsl:with-param name="header" select="'General'"/>
		</xsl:call-template>
		
		<xsl:variable name="resdoc_name">
			<xsl:call-template name="res_display_name">
			<xsl:with-param name="res" select="@name"/>
			</xsl:call-template>           
		</xsl:variable>
		<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>    
		<xsl:variable name="doctype">
			<xsl:apply-templates select="." mode="doctype"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$doctype='aic'">
					<xsl:text>This part of ISO 10303 specifies the interpretation of the integrated resources to satisfy requirements for the representation of </xsl:text>
					<xsl:value-of select="translate($resdoc_name,$ucletters,$lcletters)"/>.
					<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:when test="$doctype='igr'">
					<xsl:text>This part of ISO 10303 specifies the integrated generic resource constructs for </xsl:text>
					<xsl:value-of select="translate($resdoc_name,$ucletters,$lcletters)"/>.
					<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:when test="$doctype='iar'">
					<xsl:text>This part of ISO 10303 specifies the integrated application resource constructs for </xsl:text>
					<xsl:value-of select="translate($resdoc_name,$ucletters,$lcletters)"/>.
					<xsl:text>&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

<!-- 
<xsl:template match="resource" mode="special_header">
	<xsl:variable name="right">
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
</xsl:template> -->

	<xsl:template match="resource" mode="docnumber">
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

	
</xsl:stylesheet>

