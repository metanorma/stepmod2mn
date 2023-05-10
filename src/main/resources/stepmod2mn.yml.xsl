<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mml="http://www.w3.org/1998/Math/MathML" 
		xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:xalan="http://xml.apache.org/xalan" 
		xmlns:java="http://xml.apache.org/xalan/java" 
		xmlns:java_char="http://xml.apache.org/xalan/java/java.lang.Character" 
		xmlns:metanorma-class="xalan://org.metanorma.RegExEscaping"
		xmlns:metanorma-class-util="xalan://org.metanorma.Util"
		xmlns:redirect="http://xml.apache.org/xalan/redirect"
		exclude-result-prefixes="mml tbx xlink xalan java metanorma-class metanorma-class-util" 
		extension-element-prefixes="redirect"
		version="1.0">


	<xsl:output method="text" encoding="UTF-8"/> <!-- text, xml for debug -->

	<xsl:strip-space elements="*"/>
			
	<xsl:param name="path"/>
	<xsl:param name="outpath"/>
  
	<xsl:key name="kSchemaChanges" match="*[local-name() = 'schema.changes']" use="@schema_name"/>
	
	<!-- 
	
	<xsl:template match="@*|node()" mode="text">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="text"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="file" mode="text">
		<xsl:variable name="outfile" select="concat($outpath, '/', @path)"/>
		<redirect:write file="{$outfile}">
			<xsl:apply-templates mode="text" />
		</redirect:write>
	</xsl:template>
	
	<redirect:write file="{$outpath}/sections/99-bibliography.adoc">
=				<xsl:apply-templates select="resource" mode="bibliography"/>
			</redirect:write>
	-->
	
	<xsl:template match="/">
	
		<!-- select unique schemas -->
		<xsl:for-each select="/resource/changes/change_edition/schema.changes[generate-id(.)=generate-id(key('kSchemaChanges',@schema_name)[1])]">
			<xsl:variable name="schema_name" select="@schema_name"/>
			<xsl:text>---</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>schema: </xsl:text><xsl:value-of select="$schema_name"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>change_edition:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			
			<xsl:for-each select="ancestor::changes/change_edition[schema.changes/@schema_name = $schema_name]">
				<xsl:text>- version: </xsl:text><xsl:value-of select="@version"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:apply-templates mode="change_edition">
					<xsl:with-param name="schema_name" select="$schema_name"/>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="@*|node()" mode="change_edition">
		<xsl:param name="schema_name"/>
		<xsl:apply-templates select="@*|node()" mode="change_edition">
			<xsl:with-param name="schema_name" select="$schema_name"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="schema.changes" mode="change_edition">
		<xsl:param name="schema_name"/>
		<xsl:if test="@schema_name = $schema_name">
			<xsl:apply-templates mode="change_edition"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="description" mode="change_edition">
		<xsl:text>  description: </xsl:text>
		<xsl:value-of select="normalize-space()"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template match="schema.additions" mode="change_edition">
		<xsl:text>  additions:</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates mode="change_edition"/>
	</xsl:template>
	
	<xsl:template match="schema.modifications" mode="change_edition">
		<xsl:text>  modifications:</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates mode="change_edition"/>
	</xsl:template>
	
	<xsl:template match="modified.object" mode="change_edition">
		<!-- Example: <modified.object type="ENTITY" name="above_plane"/> -->
		<xsl:text>  - type: </xsl:text><xsl:value-of select="@type"/>
		<xsl:text>&#xa;</xsl:text>
    <xsl:text>    name: </xsl:text><xsl:value-of select="@name"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates select="@^[not(local-name() = 'type') and not(local-name() = 'name')]" mode="change_edition"/>
		<xsl:apply-templates mode="change_edition"/>
	</xsl:template>
	
	<xsl:template match="modified.object/@*" mode="change_edition">
		<xsl:text>    </xsl:text><xsl:value-of select="local-name()"/><xsl:text>: </xsl:text><xsl:value-of select="."/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template match="modified.object/description" mode="change_edition">
		<xsl:text>    description: </xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>