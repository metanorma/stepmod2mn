<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?> -->

<!--
$Id: sect_3_defs.xsl,v 1.6 2010/02/03 23:18:57 lothartklein Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalan="http://xml.apache.org/xalan" 
	exclude-result-prefixes="xalan"
                version="1.0">

<!--   <xsl:import href="resource.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
<!--   <xsl:import href="resource_clause.xsl"/> -->


  <xsl:output method="html"/>

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource" mode="terms_definitions_resource"> <!-- called from stepmod2mn.resource.adoc.xsl  -->
  <!-- Output the terms identified in the normative references -->
  <!-- <h2 level="1">
    <a name="defns"> -->
      <!--
      <xsl:choose>
        <xsl:when test="./definition/term">
          3 Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise>
          3 Terms and abbreviations
        </xsl:otherwise>
      </xsl:choose>
-->
      <!-- <xsl:choose>
        <xsl:when test="./abbreviation">
          Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise> -->
          <!-- every module references Terms defined in other standards,
               and abbreviations hence as per ISO -->
         <!--  Terms, definitions and abbreviated terms
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </h2> -->
	
	<!-- https://github.com/metanorma/stepmod2mn/issues/145#issuecomment-2069004086:
	
		== Terms, definitions and abbreviated terms

		[source=ISO_10303_2]
		=== Terms and definitions
	-->
	<!-- ISO 1303-2 is published so no footnote needed -->
	
	<xsl:variable name="header">Terms, definitions and abbreviated terms</xsl:variable>
		
	<xsl:text>&#xa;</xsl:text>
	
	<!-- get a list of normative references that have terms defined -->
	<xsl:variable name="normrefs">
		<xsl:call-template name="normrefs_terms_list">
			<xsl:with-param name="current_resource" select="./@part"/>
		</xsl:call-template>
	</xsl:variable>
	<!-- list of the references -->
	<xsl:variable name="list_ref">
		<xsl:call-template name="get_list_normrefs_terms_rec">
			<xsl:with-param name="normrefs" select="$normrefs"/>
			<xsl:with-param name="normref_ids" select="$normrefs"/>
			<xsl:with-param name="section" select="0"/>
			<xsl:with-param name="resource_number" select="./@part"/>
			<xsl:with-param name="current_resource" select="."/>
		</xsl:call-template>
	</xsl:variable>
	<!-- debug:<xsl:apply-templates select="xalan:nodeset($list_ref)" mode="print_as_xml"/> -->
	<!-- from https://github.com/metanorma/stepmod2mn/issues/145#issuecomment-2076664788 
	 it means all "ISO 10303-*" parts should be omitted, because ISO 10303-2 is a new publication that includes all terms.
		 This means once we include ISO 10303-2 in the source, 
		 we do not need to import any other term from any ISO 10303-* document. -->
	<xsl:variable name="attributes">
		<xsl:if test="xalan:nodeset($list_ref)//item[contains(., 'ISO 10303-')]">source=ref10303-2</xsl:if>
	</xsl:variable>
	
	<xsl:call-template name="insertHeaderADOC">
		<xsl:with-param name="id" select="'defns'"/>
		<xsl:with-param name="attributes" select="normalize-space($attributes)"/>
		<xsl:with-param name="level" select="1"/>
		<xsl:with-param name="header" select="$header"/>					
	</xsl:call-template>
	
    <!-- <h2 level="2">
      <a name="termsdefns">
        Terms and definitions
      </a>        
    </h2>   -->

	<xsl:if test="count(xalan:nodeset($list_ref)//item[contains(., 'ISO 10303-')]) = count(xalan:nodeset($list_ref)//item)">
		<xsl:call-template name="insertHeaderADOC">
			<xsl:with-param name="id" select="'termsdefns'"/>
			<xsl:with-param name="attributes" select="'heading=terms and definitions'"/>
			<xsl:with-param name="level" select="2"/>
			<xsl:with-param name="header" select="'Terms and definitions'"/>					
		</xsl:call-template>
	</xsl:if>
  
  <xsl:call-template name="output_terms">
    <xsl:with-param name="current_resource" select="."/>
    <xsl:with-param name="resource_number" select="./@part"/>
  </xsl:call-template>

   <!-- <p>For the purposes of this document, the terms and definitions given
    in ISO 10303-2 <sup><a href="#tobepub">1</a>)</sup> apply.</p>
    <p>ISO and IEC maintain terminology databases for use in standardization
    at the following addresses:</p>
    <table>
      <tr>
	<td>— ISO Online browsing platform: available at <a href="https://www.iso.org/obp" target="_blank">https://www.iso.org/obp</a>;</td>
      </tr>
      <tr>
	<td>— IEC Electropedia: available at <a href="https://www.electropedia.org/" target="_blank">https://www.electropedia.org/</a>.</td>
      </tr>
    </table> -->

    <!-- <xsl:call-template name="output_abbreviations">
      <xsl:with-param name="section" select="2"/>
    </xsl:call-template> -->

    <!-- <table width="500">
      <tr>
        <td><hr/></td>
      </tr>
      <tr>
        <td>
          <a name="tobepub">
            <sup>1)</sup> Under preparation. Stage at time of publication: ISO/FDIS 10303-2:2023</a>
        </td>
      </tr>
    </table> -->
	
</xsl:template>
  
</xsl:stylesheet>
