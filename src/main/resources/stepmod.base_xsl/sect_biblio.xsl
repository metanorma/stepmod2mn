<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_biblio.xsl,v 1.12 2010/11/09 11:22:54 radack Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xalan="http://xml.apache.org/xalan"
	version="1.0">
<!-- 	<xsl:import href="module.xsl"/>-->
	<!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
	<!-- <xsl:import href="module_clause.xsl"/>
	<xsl:import href="projmg/issues.xsl"/>
	<xsl:import href="elt_list.xsl"/>
	<xsl:include href="common/biblio.xsl"/> -->
	<xsl:output method="html"/>
	<!-- overwrites the template declared in module.xsl -->
	<xsl:template match="module" mode="bibliography">
		<!-- <div align="left">
			<h2>
				<A NAME="bibliography">Bibliography</A>
			</h2>
		</div> -->
    <xsl:text>[bibliography]</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:call-template name="insertHeaderADOC">
      <!-- <xsl:with-param name="id" select="'bibliography'"/>		 -->
      <xsl:with-param name="level" select="1"/>
      <xsl:with-param name="header" select="'Bibliography'"/>		
    </xsl:call-template>
    
		<!-- output any issues -->
		<xsl:apply-templates select="." mode="output_clause_issue">
			<xsl:with-param name="clause" select="'bibliography'"/>
		</xsl:apply-templates>
		<xsl:choose>
			<xsl:when test="./bibliography">
				<xsl:apply-templates select="./bibliography">
					<xsl:with-param name="doc_type">module</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- output the defaults -->
        <!-- <xsl:variable name="bibliography_default_xml" select="document(concat($path,'../../../../basic/bibliography_default.xml'))"/> -->
        <xsl:variable name="bibliography_default_xml" select="document(concat($path,'../../basic/bibliography_default.xml'))"/>
				<xsl:apply-templates select="$bibliography_default_xml/bibliography">
					<xsl:with-param name="doc_type">module</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		<!-- check that all bibitems have been published, if not output footnote -->
		<xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote">
			<xsl:with-param name="doc_type">module</xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:variable name="bibliographic_entries_collection">
			<xsl:for-each select="//module_ref">
				<xsl:variable name="bibliographic_entry_collection">
					<xsl:apply-templates select="."/>
				</xsl:variable>
				<!-- Input bibliographic_entry_collection = <<doc_iso10303-1130,anchor=scope>> -->
				<!-- Output : * [[[doc_iso10303-54,repo:(current-metanorma-collection/iso10303-54)]]] (Derived shape element). -->
				<xsl:variable name="bibitem_id" select="substring-before(substring-after($bibliographic_entry_collection,'&lt;&lt;'),',')"/>
				<xsl:if test="starts-with($bibitem_id, 'doc_')">
					<item>
						<xsl:variable name="doc_id" select="substring-after($bibitem_id, 'doc_')"/>
						<xsl:variable name="doc_title" select="."/>
						<xsl:value-of select="concat('* [[[', $bibitem_id, ',repo:(current-metanorma-collection/', $doc_id, ')]]] (', $doc_title, ').')"/>
					</item>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($bibliographic_entries_collection)/item">
			<xsl:if test="not(preceding-sibling::*[. = current()])">
				<xsl:value-of select="."/>
				<xsl:text>&#xa;&#xa;</xsl:text>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	<!-- MWD START -->
	<xsl:template match="resource" mode="bibiliog">
		<div align="left">
			<h2>
				<A NAME="bibliography">Bibliography</A>
			</h2>
		</div>
		<!-- output any issues -->
		<!--<xsl:apply-templates select="." mode="output_clause_issue">
			<xsl:with-param name="clause" select="'bibliography'"/>
		</xsl:apply-templates>-->
		<xsl:choose>
			<xsl:when test="./bibliography">
				<xsl:apply-templates select="./bibliography">
					<xsl:with-param name="doc_type">resource</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<!-- <xsl:otherwise>
				<!-\- output the defaults -\->
				<xsl:apply-templates select="document('../../basic/bibliography_default.xml',.)/bibliography">
					<xsl:with-param name="doc_type">resource</xsl:with-param>
				</xsl:apply-templates>
				</xsl:otherwise> -->
		</xsl:choose>
		<!-- check that all bibitems have been published, if not output footnote -->
		<!-- <xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote">
			<xsl:with-param name="doc_type">resource</xsl:with-param>
		</xsl:apply-templates>-->
	</xsl:template>
	<!-- MWD END -->
</xsl:stylesheet>
