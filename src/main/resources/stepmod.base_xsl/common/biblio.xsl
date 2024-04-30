<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: biblio.xsl,v 1.5 2010/11/09 00:51:07 radack Exp $
  -->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan" version="1.0">
	<!-- <xsl:variable name="bib_file">../../data/basic/bibliography.xml</xsl:variable> -->
	<xsl:variable name="bib_file"><xsl:value-of select="$path"/>../../../data/basic/bibliography.xml</xsl:variable>
	<xsl:template name="get_bib_file">
		<xsl:param name="doc_type"/>
		<xsl:value-of select="$bib_file"/>
	</xsl:template>
	<xsl:template match="bibliography">
		<xsl:param name="doc_type"/>
		<xsl:variable name="bib_file">
			<xsl:call-template name="get_bib_file">
				<xsl:with-param name="doc_type" select="$doc_type"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="./bibitem.inc[@ref='ref8824-1']">
				<!-- bibliography contains reference to ISO/IEC 8824-1 -->
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:call-template name="error_message">
					<xsl:with-param name="message" select="'Bibliography error: missing reference to ISO/IEC 8824-1#Add &lt;bibitem.inc ref=&quot;ref8824-1&quot;/&gt;'"/>
				</xsl:call-template> -->
				<xsl:message>[WARNING] added missing bibliography reference to ISO/IEC 8824-1.</xsl:message>
				<xsl:text>* [[[bibitem_ref8824-1,ISO/IEC 8824-1]]], ISO/IEC 8824-1, Information technology — Abstract Syntax Notation One (ASN.1) — Part 1: Specification of basic notation.</xsl:text>
				<xsl:text>&#xa;&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$doc_type='module'">
				<xsl:if test="not(./bibitem.inc[@ref='AMConGde06'])">
					<!-- <xsl:call-template name="error_message">
						<xsl:with-param name="message" select="'Bibliography error: missing reference to Guidelines for the content of application modules#Add &lt;bibitem.inc ref=&quot;AMConGde06&quot;/&gt;'"/>
					</xsl:call-template> -->
					<xsl:message>[WARNING] added missing bibliography reference to Guidelines for the content of application modules.</xsl:message>
					<xsl:text>* [[[bibitem_AMConGde06,ISO TC 184/SC 4 N1685]]], Guidelines for the content of application modules. ISO TC 184/SC 4 N1685, 2004-02-27.</xsl:text>
					<xsl:text>&#xa;&#xa;</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$doc_type='AP'">
				<xsl:if test="not(./bibitem.inc[@ref='APConGde'])">
					<!-- <xsl:call-template name="error_message">
						<xsl:with-param name="message" select="'Bibliography error: missing reference to Guidelines for the content of application protocols that use application modules#Add &lt;bibitem.inc ref=&quot;APConGde&quot;/&gt;'"/>
					</xsl:call-template> -->
					<xsl:message>[WARNING] added missing bibliography reference to Guidelines for the content of application protocols that use application modules.</xsl:message>
					<xsl:text>* [[bibitem_APConGde, ISO TC 184/SC 4 N1863]]], Guidelines for the content of application protocols that use application modules. ISO TC 184/SC 4 N1863, 2005</xsl:text>
					<xsl:text>&#xa;&#xa;</xsl:text>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="./*">
			<xsl:with-param name="number_start" select="0"/>
			<xsl:with-param name="bib_file" select="$bib_file"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="bibitem|bibitem.ap|bibitem.resource|bibitem.techreport|bibitem.book">
		<!-- the value from which to start the counting. -->
		<xsl:param name="number_start" select="0"/>
		<!-- 
	 the value to be used for the number. This is used if the bibitem
	 is being displayed from a bibitem.inc
      -->
		<xsl:param name="number_inc" select="0"/>
		<xsl:variable name="number">
			<!-- if the number is provided, use it, else count -->
			<xsl:choose>
				<xsl:when test="$number_inc>0">
					<xsl:value-of select="$number_inc"/>
				</xsl:when>
				<xsl:otherwise>
					<!--<xsl:number count="bibitem"/>-->
					<xsl:number count="*" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="number">
			<xsl:choose>
				<xsl:when test="stdnumber"><xsl:value-of select="stdnumber"/></xsl:when>
				<xsl:when test="number"><xsl:value-of select="number"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate($number, '/  ', '___')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="frag" select="concat('bibitem_',$id)"/>
    <!-- <xsl:apply-templates select="." mode="print_as_xml"/> -->
		<!-- <p>
			<A NAME="{$frag}"/>

			[<xsl:value-of select="$number_start+$number"/>] 
      <xsl:apply-templates select="." mode="bibitem_content"/>
			<xsl:apply-templates select="ulink"/>
		</p> -->
    
    <xsl:text>* [[[</xsl:text>
		<xsl:value-of select="$frag"/>
    <xsl:choose>
      <xsl:when test="stdnumber">,<xsl:value-of select="stdnumber"/></xsl:when>
      <xsl:when test="number">,<xsl:value-of select="number"/></xsl:when>
    </xsl:choose>
		<xsl:text>]]], </xsl:text>
    <xsl:variable name="bibitem_text">
      <xsl:apply-templates select="." mode="bibitem_content"/>
      <xsl:apply-templates select="ulink"/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($bibitem_text)"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
    
	</xsl:template>
	<!-- item is a standard -->
	<xsl:template match="bibitem" mode="bibitem_content">
		<xsl:if test="stdnumber">
			<xsl:apply-templates select="stdnumber"/>
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="stdtitle"/>
		<xsl:if test="subtitle">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="subtitle"/>
		<xsl:if test="pubdate and not(starts-with(stdnumber,'ISO'))">
			<!-- only going to use pubdate if NON ISO standard, 
           ISO standard will have date in stdnumber - see stdnumber
           template -->
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="pubdate"/>
		<!--<xsl:text>.</xsl:text> MWD 2020-01-07 -->
	</xsl:template>
	<!-- item is a technical report -->
	<xsl:template match="bibitem.techreport" mode="bibitem_content">
		<xsl:variable name="elt_list">
			<elt-list separator="." terminator="." name="top-level">
				<elt-list name="primary-responsibility">
					<elt name="primary-responsibility">
						<xsl:value-of select="normalize-space(primary-responsibility)"/>
					</elt>
				</elt-list>
				<elt name="stdtitle">
					<i>
						<xsl:value-of select="normalize-space(stdtitle)"/>
					</i>
				</elt>
				<elt-list separator="," name="report-type,number,institution,pubdate">
					<elt-list name="report-type,number">
						<elt name="report-type">
							<xsl:value-of select="normalize-space(report-type)"/>
						</elt>
						<elt name="number">
							<xsl:value-of select="normalize-space(number)"/>
						</elt>
					</elt-list>
					<elt name="institution">
						<xsl:value-of select="normalize-space(institution)"/>
					</elt>
					<elt name="pubdate">
						<xsl:value-of select="normalize-space(pubdate)"/>
					</elt>
				</elt-list>
			</elt-list>
		</xsl:variable>
		<xsl:call-template name="render_elt_list">
			<xsl:with-param name="elt_list" select="$elt_list"/>
		</xsl:call-template>
	</xsl:template>
	<!-- item is a monograph -->
	<xsl:template match="bibitem.book" mode="bibitem_content">
		<xsl:variable name="elt_list">
			<elt-list separator="." terminator="." name="top-level">
				<elt-list name="primary-responsibility">
					<elt name="primary-responsibility">
						<xsl:value-of select="normalize-space(primary-responsibility)"/>
					</elt>
				</elt-list>
				<elt name="stdtitle">
					<i>
						<xsl:value-of select="normalize-space(stdtitle)"/>
					</i>
				</elt>
				<elt name="edition">
					<xsl:value-of select="normalize-space(edition)"/>
				</elt>
				<elt-list separator="," name="report-type,number,publisher,pubdate">
					<elt-list name="place,publisher" separator=" :">
						<elt name="place">
							<xsl:value-of select="normalize-space(place)"/>
						</elt>
						<elt name="publisher">
							<xsl:value-of select="normalize-space(publisher)"/>
						</elt>
					</elt-list>
					<elt name="pubdate">
						<xsl:value-of select="normalize-space(pubdate)"/>
					</elt>
				</elt-list>
			</elt-list>
		</xsl:variable>
		<xsl:call-template name="render_elt_list">
			<xsl:with-param name="elt_list" select="$elt_list"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="bibitem.inc">
		<!-- the value from which to start the counting. -->
		<xsl:param name="number_start" select="0"/>
		<xsl:param name="bib_file"/>
		<xsl:variable name="ref" select="@ref"/>
		<xsl:variable name="bib_file_document" select="document(string($bib_file))"/>
		<xsl:variable name="bibitem" select="$bib_file_document/bibitem.list/node()[starts-with(local-name(),'bibitem') and (@id=$ref)][1]"/>
		<xsl:choose>
			<xsl:when test="$bibitem">
				<xsl:apply-templates select="$bibitem">
					<xsl:with-param name="number_start" select="$number_start"/>
					<xsl:with-param name="number_inc" select="position()"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message" select="concat('Error 13: Cannot find bibitem referenced by: ',$ref,
                     ' in ', $bib_file, '.')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="orgname">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="stdnumber">
		<!-- 
	 ISO documents should be date referenced and have the stdnumber form
	 ISO 10303-41:2000
	 People are inconsistent as to whether they included the date in the stdnumber
	 <stdnumber>ISO 10303-41:2000</stdnumber>
	 or <pubdate> -->
		<xsl:variable name="stdnumber" select="normalize-space(.)"/>
		<xsl:choose>
			<xsl:when test="starts-with($stdnumber,'ISO')">
				<xsl:choose>
					<!-- date in the stdnumber -->
					<xsl:when test="contains($stdnumber,':')">
						<xsl:value-of select="$stdnumber"/>
					</xsl:when>
					<!-- date in the pubdate -->
					<xsl:when test="../pubdate">
						<xsl:value-of select="concat($stdnumber,':',../pubdate)"/>
					</xsl:when>
					<!-- no date provided -->
					<xsl:otherwise>
						<xsl:value-of select="$stdnumber"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- a non ISO standard -->
			<xsl:otherwise>
				<xsl:value-of select="$stdnumber"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="../@published='n'">
			<sup>
	&#160;<a href="#tobepub">1</a>
				<xsl:text>)</xsl:text>
			</sup>
		</xsl:if>
	</xsl:template>
	<xsl:template match="primary-responsibility">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	<xsl:template match="stdtitle">
		<i>
			<xsl:value-of select="normalize-space(.)"/>
		</i>
	</xsl:template>
	<xsl:template match="subtitle">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	<xsl:template match="pubdate">
		<!-- If  an ISO standard then the pub date should already be in the
	 stdnumber, so do not output it -->
		<xsl:variable name="stdnumber" select="normalize-space(../stdnumber)"/>
		<xsl:if test="not(starts-with($stdnumber,'ISO'))">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ulink">
		<xsl:text> Available at: </xsl:text>
		<xsl:variable name="href" select="normalize-space(.)"/>
		<xsl:text>&lt;</xsl:text>
		<a href="{$href}">
			<xsl:value-of select="$href"/>
		</a>
		<xsl:text>&gt;.</xsl:text>
	</xsl:template>
	<!-- check that all bibitems have been published, if not output
       footnote -->
	<xsl:template match="bibliography" mode="unpublished_bibitems_footnote">
		<xsl:param name="doc_type"/>
		<xsl:variable name="bib_file">
			<xsl:call-template name="get_bib_file">
				<xsl:with-param name="doc_type" select="$doc_type"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- collect up all bibitems -->
		<xsl:variable name="bibitems">
			<bibitems>
				<!-- collect up the documents -->
				<xsl:apply-templates select="." mode="collect_bibitems">
					<xsl:with-param name="bib_file" select="$bib_file"/>
				</xsl:apply-templates>
			</bibitems>
		</xsl:variable>
		<!-- <xsl:choose>
			<xsl:when test="function-available('msxsl:node-set')">
				<xsl:variable name="bibitem_nodes" select="msxsl:node-set($bibitems)"/>
				<xsl:if test="$bibitem_nodes//bibitem[@published='n']">
					<table width="200">
						<tr>
							<td>
								<hr/>
							</td>
						</tr>
						<tr>
							<td>
								<a name="tobepub">
									<sup>1)</sup> To be published.
		</a>
							</td>
						</tr>
					</table>
				</xsl:if>
			</xsl:when>
			<xsl:when test="function-available('exslt:node-set')">
				<xsl:variable name="bibitem_nodes" select="exslt:node-set($bibitems)"/>
				<xsl:if test="$bibitem_nodes//bibitem[@published='n']">
					<table width="200">
						<tr>
							<td>
								<hr/>
							</td>
						</tr>
						<tr>
							<td>
								<a name="tobepub">
									<sup>1)</sup> To be published.
		</a>
							</td>
						</tr>
					</table>
				</xsl:if>
			</xsl:when>
		</xsl:choose> -->
    
    <xsl:variable name="bibitem_nodes" select="xalan:nodeset($bibitems)"/>
    <!-- <xsl:if test="$bibitem_nodes//bibitem[@published='n']">
      <table width="200">
        <tr>
          <td>
            <hr/>
          </td>
        </tr>
        <tr>
          <td>
            <a name="tobepub">
              <sup>1)</sup> To be published.
</a>
          </td>
        </tr>
      </table>
    </xsl:if> -->
    
	</xsl:template>
	<!-- collect up all bibitems in order to check for unpublished bib items -->
	<xsl:template match="bibliography" mode="collect_bibitems">
		<xsl:param name="bib_file"/>
		<xsl:variable name="bib_file_document" select="document(string($bib_file))"/>
		<xsl:variable name="bibitem_list" select="$bib_file_document/bibitem.list"/>
		<xsl:for-each select="bibitem">
			<xsl:element name="bibitem">
				<xsl:if test="@published='n'">
					<xsl:attribute name="published"><xsl:value-of select="'n'"/></xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
		<xsl:for-each select="bibitem.inc">
			<xsl:variable name="ref" select="@ref"/>
			<xsl:variable name="bibitem_inc" select="$bibitem_list/bibitem[@id=$ref][1]"/>
			<xsl:element name="bibitem">
				<xsl:if test="$bibitem_inc/@published='n'">
					<xsl:attribute name="published"><xsl:value-of select="'n'"/></xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="bibitem.ap" mode="bibitem_content">
		<!-- the value from which to start the counting. -->
		<xsl:param name="number_start" select="0"/>
		<xsl:variable name="part_name" select="@name"/>
		<xsl:variable name="ap_ok">
			<xsl:call-template name="check_application_protocol_exists">
				<xsl:with-param name="application_protocol" select="$part_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string($ap_ok)='true'">
				<xsl:variable name="ap_dir" select="concat('../../data/application_protocols/', $part_name)"/>
				<xsl:variable name="ap_xml" select="concat($ap_dir,'/application_protocol.xml')"/>
				<xsl:variable name="ap_nodes" select="document(string($ap_xml))"/>
				<xsl:variable name="number" select="position()"/>
				<!-- <p>
          [<xsl:value-of select="$number_start+$number"/>] 
          <xsl:apply-templates select="$ap_nodes/application_protocol" mode="bibitem"/>
				</p> -->
        
        <xsl:variable name="stdnumber">
          <xsl:call-template name="get_protocol_stdnumber">
            <xsl:with-param name="application_protocol" select="$ap_nodes/application_protocol"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="id" select="translate($stdnumber, '/  ', '_')"/>
        
        <xsl:text>* [[[</xsl:text>
        <xsl:value-of select="concat('bibitem_',$id)"/>
        <xsl:choose>
          <xsl:when test="stdnumber">,<xsl:value-of select="stdnumber"/></xsl:when>
          <xsl:when test="number">,<xsl:value-of select="number"/></xsl:when>
        </xsl:choose>
        <xsl:text>]]], </xsl:text>
        <xsl:variable name="bibitem_text">
          <xsl:apply-templates select="$ap_nodes/application_protocol" mode="bibitem"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($bibitem_text)"/>
        <xsl:text>&#xa;&#xa;</xsl:text>
        
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error bib 1: ', $ap_ok,
		       'Check the bibliography ')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="bibitem.module">
		<!-- the value from which to start the counting. -->
		<xsl:param name="number_start" select="0"/>
		<xsl:variable name="module" select="@name"/>
		<xsl:variable name="module_ok">
			<xsl:call-template name="check_module_exists">
				<xsl:with-param name="module" select="$module"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$module_ok='true'">
				<xsl:variable name="module_dir">
					<xsl:call-template name="module_directory">
						<xsl:with-param name="module" select="$module"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- <xsl:variable name="module_xml" select="concat('../',$module_dir,'/module.xml')"/> -->
				<xsl:variable name="module_xml" select="concat($module_dir,'/module.xml')"/>
        
				<xsl:variable name="module_nodes" select="document(string($module_xml))"/>
				<xsl:variable name="number" select="position()"/>
				<!-- <p>
          [<xsl:value-of select="$number_start+$number"/>] 
          <xsl:apply-templates select="$module_nodes/module" mode="bibitem"/>
				</p> -->
        <!-- <xsl:apply-templates select="$module_nodes/module" mode="print_as_xml"/> -->
        
        <xsl:variable name="stdnumber">
          <xsl:call-template name="get_module_stdnumber_undated">
            <xsl:with-param name="module" select="$module_nodes/module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="id" select="translate($stdnumber, '/  ', '_')"/>
        
        <xsl:text>* [[[</xsl:text>
        <xsl:value-of select="concat('bibitem_',$id)"/>
        <xsl:choose>
          <xsl:when test="stdnumber">,<xsl:value-of select="stdnumber"/></xsl:when>
          <xsl:when test="number">,<xsl:value-of select="number"/></xsl:when>
          <xsl:when test="normalize-space($stdnumber) != ''">,<xsl:value-of select="$stdnumber"/></xsl:when>
        </xsl:choose>
        <xsl:text>]]], </xsl:text>
        <xsl:variable name="bibitem_text">
          <xsl:apply-templates select="$module_nodes/module" mode="bibitem"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($bibitem_text)"/>
        <xsl:text>&#xa;&#xa;</xsl:text>
        
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error bib 1: ', $module_ok,
		       'Check the bibliography ')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="bibitem.resource" mode="bibitem_content">
		<!-- the value from which to start the counting. -->
		<xsl:param name="number_start" select="0"/>
		<xsl:variable name="resdoc" select="@name"/>
		<xsl:variable name="resdoc_ok">
			<xsl:call-template name="check_resdoc_exists">
				<xsl:with-param name="resdoc" select="$resdoc"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string($resdoc_ok)='true'">
				<xsl:variable name="resdoc_dir" select="concat('../../data/resource_docs/', $resdoc)"/>
				<xsl:variable name="resdoc_xml" select="concat($resdoc_dir,'/resource.xml')"/>
				<xsl:variable name="resdoc_nodes" select="document(string($resdoc_xml))"/>
				<xsl:variable name="number" select="position()"/>
				<!-- <p>
          [<xsl:value-of select="$number_start+$number"/>] 
          <xsl:apply-templates select="$resdoc_nodes/resource" mode="bibitem"/>
				</p> -->
        
        <xsl:variable name="stdnumber">
          <xsl:call-template name="get_protocol_stdnumber">
            <xsl:with-param name="application_protocol" select="$resdoc_nodes/resource"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="id" select="translate($stdnumber, '/  ', '_')"/>
        
        <xsl:text>* [[[</xsl:text>
        <xsl:value-of select="concat('bibitem_',$id)"/>
        <xsl:choose>
          <xsl:when test="stdnumber">,<xsl:value-of select="stdnumber"/></xsl:when>
          <xsl:when test="number">,<xsl:value-of select="number"/></xsl:when>
        </xsl:choose>
        <xsl:text>]]], </xsl:text>
        <xsl:variable name="bibitem_text">
          <xsl:apply-templates select="$resdoc_nodes/resource" mode="bibitem"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($bibitem_text)"/>
        <xsl:text>&#xa;&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error bib 1: ', $resdoc_ok,
		       'Check the bibliography ')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
