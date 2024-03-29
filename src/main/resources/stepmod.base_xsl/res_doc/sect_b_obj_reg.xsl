<?xml version="1.0" encoding="utf-8"?>

<!--
$Id: sect_b_obj_reg.xsl,v 1.9 2012/11/14 23:16:12 lothartklein Exp $
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
<!--   <xsl:import href="resource_clause.xsl"/>


	<xsl:output method="html"/> -->

	<!-- overwrites the template declared in module.xsl -->
	<xsl:template match="resource" mode="annex_b">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'B'"/>
			<xsl:with-param name="annex_id" select="'info_object_reg'"/>
			<xsl:with-param name="heading" select="'Information object registration'"/>
			<xsl:with-param name="aname" select="'annexb'"/>
			<xsl:with-param name="informative" select="'normative'"/>
		</xsl:call-template>

		<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ_</xsl:variable>
		<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
		
		<xsl:variable name="resdoc_dir">
			<xsl:call-template name="resdoc_directory">
				<xsl:with-param name="resdoc" select="@name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="object_reg">
			<xsl:choose>
			<xsl:when test="@object.reg.version"> 
				<xsl:value-of  select="concat('{ iso standard 10303 part(',@part,') version(',@object.reg.version,')')"/> 
			</xsl:when>
				<xsl:otherwise>
					<xsl:value-of  select="concat('{ iso standard 10303 part(',@part,') version(',@version,')')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<!-- added variable for just the part number -->
		<xsl:variable name="object_reg_minus_version" select="concat('{ iso standard 10303 part(',@part,')')"/>

		<!-- <h2>
			<a name="b1">
				B.1 Document Identification
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
			
			<!-- <p align="center">
				<xsl:value-of select="concat($object_reg,' }' )"/>
			</p> -->
			
			<xsl:text>[align=center]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:call-template name="insertParagraph">
				<xsl:with-param name="text">
					<xsl:value-of select="concat($object_reg,' }' )"/>
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- <p> -->
			<xsl:call-template name="insertParagraph">
				<xsl:with-param name="text">
				is assigned to this part of ISO 10303. The meaning of this value is defined
		in ISO/IEC 8824-1, and is described in ISO 10303-1.  
				</xsl:with-param>
			</xsl:call-template>
			<!-- </p> -->
			<!-- <h2>
			<a name="b2">
				B.2 Schema identification
			</a>
		</h2> -->
		<xsl:call-template name="insertHeaderADOC">
			<xsl:with-param name="id" select="'b2'"/>		
			<xsl:with-param name="level" select="2"/>
			<xsl:with-param name="header" select="'Schema identification'"/>					
		</xsl:call-template>
		

		<!-- there is are potentially several  schemas in an integrated resource -->
		<!-- for now I will just get the names from the resource.xml rather than go to the schemas --> 
	 <!-- from bug #4660 added schema version as separate variable -->
	 <xsl:for-each select="./schema">
		 <xsl:variable name="schema" select="translate(@name,$UPPER, $LOWER)" />
		 <xsl:variable name="schema_version" select="concat(' version(', @version, ')')" />
		 <!-- <h2>B.2.<xsl:value-of select="concat(position(),  ' ')"/><xsl:value-of select="$schema"/> schema identification</h2> -->
		 
			<xsl:call-template name="insertHeaderADOC">				
				<xsl:with-param name="level" select="3"/>
				<xsl:with-param name="header"><xsl:value-of select="$schema"/> schema identification</xsl:with-param>
			</xsl:call-template>

		<!-- <p> -->
			<xsl:call-template name="insertParagraph">
				<xsl:with-param name="text">
				To provide for unambiguous identification of the schema specifications
				given in this integrated resource in an open information system, the object
				identifiers are assigned as follows: 
				</xsl:with-param>
			</xsl:call-template>
		<!-- </p> -->
		<!-- <p align="center">
			<xsl:value-of select="concat($object_reg_minus_version, $schema_version, ' object(1) ', $schema,'(', position(), ') }' )"/>
		</p> -->
		
		<xsl:text>[align=center]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
				<xsl:value-of select="concat($object_reg_minus_version, $schema_version, ' object(1) ', $schema,'(', position(), ') }' )"/>				
			</xsl:with-param>
		</xsl:call-template>
		
		<!-- <p> -->
		<xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
				is assigned to the <xsl:value-of select="$schema"/> schema. 
				The meaning of this value is defined in ISO/IEC 8824-1, and is described in
				ISO 10303-1.  
			</xsl:with-param>
		</xsl:call-template>
		<!-- </p> -->

	</xsl:for-each>

	</xsl:template>
	
</xsl:stylesheet>