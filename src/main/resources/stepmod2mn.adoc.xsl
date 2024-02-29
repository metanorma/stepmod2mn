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
	
	
	<xsl:template name="getLanguage">
		<xsl:choose>
			<xsl:when test="resource">
				<xsl:variable name="lang" select="java:toLowerCase(java:java.lang.String.new(resource/@language))"/>
				<xsl:choose>
					<xsl:when test="$lang = 'e'">en</xsl:when> 
					<xsl:when test="$lang = 'd'">de</xsl:when> 
					<xsl:when test="$lang = 'z'">zh</xsl:when> 
					<xsl:otherwise><xsl:value-of select="resource/@language"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lang" select="java:toLowerCase(java:java.lang.String.new(module/@language))"/>
				<xsl:choose>
					<xsl:when test="$lang = 'e'">en</xsl:when> 
					<xsl:when test="$lang = 'd'">de</xsl:when> 
					<xsl:when test="$lang = 'z'">zh</xsl:when> 
					<xsl:otherwise><xsl:value-of select="module/@language"/></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertHeaderADOC">
		<xsl:param name="id"/>
		<xsl:param name="attributes"/>
		<xsl:param name="level" select="1"/>
		<xsl:param name="header"/>		
		<xsl:param name="annex_no"/>		
		<xsl:param name="annex_id"/>		
		<xsl:param name="obligation"/>
		<xsl:param name="indexed" select="'false'"/>
		<xsl:param name="index_term">term</xsl:param> <!-- default -->
    <xsl:param name="index_term2"/>
    <xsl:param name="index_term3"/>
		<xsl:choose>
			<xsl:when test="$annex_no != '' or $annex_id != ''">
				<xsl:text>[[</xsl:text>
				<xsl:choose>
					<xsl:when test="$annex_id != ''"><xsl:value-of select="$annex_id"/></xsl:when>
					<xsl:otherwise><xsl:text>Annex</xsl:text><xsl:value-of select="$annex_no"/></xsl:otherwise>
				</xsl:choose>
				<xsl:text>]]</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:when test="$id != ''">
			<xsl:text>[[</xsl:text>
				<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="$attributes != ''">
			<xsl:text>[</xsl:text>
				<xsl:value-of select="$attributes"/>
			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:if test="$annex_no != ''">
			<xsl:text>[appendix</xsl:text>
			<xsl:if test="$obligation != ''">
				<xsl:text>,obligation=</xsl:text><xsl:value-of select="$obligation"/>
			</xsl:if>
			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>		
		
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'='"/>
			<xsl:with-param name="count" select="$level + 1"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>		
		<xsl:value-of select="$header"/>
		<xsl:if test="$indexed = 'true'">
      <xsl:text> (((</xsl:text>
      <xsl:choose>
        <xsl:when test="$index_term2 != '' or $index_term3 != ''">
          <xsl:value-of select="$index_term"/>
          <xsl:text>,</xsl:text>
          <xsl:value-of select="$index_term2"/>
          <xsl:if test="$index_term3 != ''">
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$index_term3"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$header"/>
          <xsl:text>,</xsl:text>
          <xsl:value-of select="$index_term"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>)))</xsl:text>
		</xsl:if>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>


	<xsl:template name="insertParagraph">
		<xsl:param name="text"/>
		<xsl:param name="keep-with-next" select="'false'"/>
		<!-- <xsl:value-of select="normalize-space($text)"/> -->
		<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
		<xsl:if test="$keep-with-next = 'false'">
			<xsl:text>&#xa;&#xa;</xsl:text>
		</xsl:if>
	</xsl:template>


	<xsl:template name="insertULitem">
		<xsl:param name="text"/>
		<xsl:text>* </xsl:text>
		<!-- <xsl:value-of select="normalize-space($text)"/> -->
		<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>

	<xsl:template name="insertNote">
		<xsl:param name="id"/>
		<xsl:param name="schema_entity_param"/>
		<xsl:param name="text"/>
		<!-- <xsl:param name="isolated" select="'true'"/> -->
		<xsl:param name="start_only">false</xsl:param>
		
		<br/><br/>
		
		<xsl:variable name="schema_entity_">
			<xsl:choose>
				<xsl:when test="$schema_entity_param != ''"><xsl:value-of select="$schema_entity_param"/></xsl:when>
				<xsl:when test="../@linkend"><xsl:value-of select="../@linkend"/></xsl:when>
				<xsl:when test="ancestor::schema/@name"><xsl:value-of select="ancestor::schema/@name"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="schema_entity" select="normalize-space($schema_entity_)"/>
		
		<xsl:if test="normalize-space($id) != ''">
			<xsl:text>[[</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<!-- <xsl:text>&#xa;</xsl:text> -->
			<br/>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$schema_entity = ''">
				<!-- <xsl:text>NOTE: </xsl:text> -->
				<xsl:text>[NOTE]</xsl:text>
				<br/>
				<xsl:text>--</xsl:text>
				<br/>
				<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Sample:
				(*"Activity_arm.Activity.__note"
					Status information identifying the level of ...
					*)
				-->
				<xsl:text>(*"</xsl:text><xsl:value-of select="$schema_entity"/><xsl:text>.__note"</xsl:text>
				<br/>
				<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="$start_only = 'false'">
			<xsl:call-template name="insertNoteEnd">
				<xsl:with-param name="schema_entity" select="$schema_entity"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertNoteEnd">
		<xsl:param name="schema_entity"/>
		<xsl:choose>
			<xsl:when test="$schema_entity = ''">
				<xsl:text>--</xsl:text>
				<br/>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*)</xsl:text>
				<br/>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- <xsl:template name="insertNoteComplex">
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		<br/><br/>
		<xsl:if test="normalize-space($id) != ''">
			<xsl:text>[[</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<br/>
		</xsl:if>      
		<xsl:text>[NOTE]</xsl:text>
		<br/>
		<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
		<br/>
	</xsl:template> -->
	
	<xsl:template name="insertExample">
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		<xsl:param name="keep-with-previous" select="'false'"/>
		
		<xsl:choose>
			<xsl:when test="$keep-with-previous = 'true'"> +<br/>+<br/></xsl:when>
			<xsl:otherwise><br/><br/></xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="schema_entity_">
			<xsl:choose>
				<xsl:when test="../@linkend"><xsl:value-of select="../@linkend"/></xsl:when>
				<xsl:when test="ancestor::schema/@name"><xsl:value-of select="ancestor::schema/@name"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="schema_entity" select="normalize-space($schema_entity_)"/>
		
		<xsl:if test="normalize-space($id) != ''">
			<br/>
			<xsl:text>[[</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<br/>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$schema_entity = ''">
				<xsl:text>[example]</xsl:text>
				<br/>
				<xsl:text>====</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- Sample:
				(*"Activity_arm.Activity.__example"
				Change, distilling, design, ....
				*)
				-->
				<xsl:text>(*"</xsl:text><xsl:value-of select="$schema_entity"/><xsl:text>.__example"</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<br/>
		<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
		<br/>
		
		<xsl:choose>
			<xsl:when test="$schema_entity = ''">
				<xsl:text>====</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*)</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<br/>
		<xsl:if test="not(parent::li) and normalize-space(following-sibling::node()) != ''">
			<br/>
		</xsl:if>
	</xsl:template>
	
	<!-- <xsl:template match="ul/li | li" mode="stepmod2mn">
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="insertListItemLabel">
			<xsl:with-param name="list-label">*</xsl:with-param>
		</xsl:call-template>				
		<xsl:apply-templates mode="stepmod2mn"/>
		<xsl:text>&#xa;</xsl:text>
		
	</xsl:template> -->

	<!-- <xsl:template match="ol/li" mode="stepmod2mn">
		<xsl:call-template name="insertListItemLabel">
			<xsl:with-param name="list-label">.</xsl:with-param>
		</xsl:call-template>		
		<xsl:apply-templates mode="stepmod2mn"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template> -->
	
	<xsl:template name="insertListItemLabel">
		<xsl:param name="list-label"/>
		<xsl:variable name="level_" select="count(ancestor-or-self::ul) + count(ancestor-or-self::ol)"/>		
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="$level_ = 0">1</xsl:when>
				<xsl:when test="$level_ &gt; 1 and ancestor::scope/ul/li/*[1][local-name() = 'b' or local-name() = 'b2']"><xsl:value-of select="$level_ - 1"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$level_"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="list-label_">
			<xsl:choose>
				<xsl:when test="$list-label != ''"><xsl:value-of select="$list-label"/></xsl:when>
				<xsl:when test="local-name(..) = 'ol'">.</xsl:when>
				<xsl:when test="local-name(..) = 'ul'">*</xsl:when>
				<xsl:otherwise>*</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="$list-label_"/>
			<xsl:with-param name="count" select="$level"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>
	

	<xsl:template name="insertQuoteStart">
		<xsl:text>[quote]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>_____</xsl:text>
		<xsl:text>&#xa;</xsl:text>		
	</xsl:template>
	
	<xsl:template name="insertQuoteEnd">
		<xsl:text>_____</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template name="insertNoteQuoteStart">
		<xsl:text>====</xsl:text>
		<xsl:text>&#xa;</xsl:text>		
	</xsl:template>
	
	<xsl:template name="insertNoteQuoteEnd">
		<xsl:text>====</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template name="insertCodeStart">
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:text>[source]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template name="insertLutaMLCodeStart">
		<xsl:text>&#xa;</xsl:text><!-- &#xa; -->
		<!-- <xsl:text>[lutaml_source,express]</xsl:text> -->
		<xsl:text>[source%unnumbered]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template name="insertCodeEnd">
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>		
		<xsl:text>&#xa;&#xa;</xsl:text>	
	</xsl:template>

	<xsl:template name="insertEXPRESSAnnotationStart">
		<xsl:param name="name"/>
		<xsl:param name="break" select="'true'"/>
		<xsl:text>(*"</xsl:text><xsl:value-of select="$name"/><xsl:text>"</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:if test="$break = 'true'">
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertEXPRESSAnnotationEnd">
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>*)</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="pre">
		<code>
		<xsl:call-template name="insertCodeStart"/>
		<xsl:apply-templates/>
		<xsl:call-template name="insertCodeEnd"/>
		</code>
	</xsl:template>
	
	<xsl:template name="insertHyperlink">
		<xsl:param name="a"/>
		<xsl:param name="asText" select="'false'"/>
		<xsl:variable name="href">
			<xsl:choose>
				<xsl:when test="xalan:nodeset($a)/*/@HREF"><xsl:value-of select="xalan:nodeset($a)/*/@HREF"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="xalan:nodeset($a)/*/@href"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$asText = 'true'">
				<xsl:variable name="link_text" select="normalize-space(xalan:nodeset($a)/*/text())"/>
				<xsl:choose>
					<xsl:when test="$href = $link_text and (starts-with($href,'www.') or starts-with($href, 'http://') or starts-with($href, 'https://'))">
						<xsl:value-of select="$href"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$href"/><xsl:text>[</xsl:text><xsl:value-of select="$link_text"/><xsl:text>]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="ExternalDocumentReference">
					<xsl:attribute name="docid">
						<xsl:value-of select="$href"/>
					</xsl:attribute>
					<xsl:attribute name="anchor">
						<xsl:value-of select="normalize-space(xalan:nodeset($a)/*/text())"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertHyperlinkSkip"/>
	
	<xsl:template name="insertImage">
		<xsl:param name="id"/>
		<xsl:param name="title"/>
		<xsl:param name="path"/>
		<xsl:param name="alttext"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:if test="normalize-space($id) != ''">
		<xsl:text>[[</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:if test="normalize-space($title) != ''">
			<xsl:text>.</xsl:text><xsl:value-of select="$title"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:text>image::</xsl:text>
		<xsl:value-of select="$path"/>
		<xsl:text>[</xsl:text>
		<xsl:value-of select="$alttext"/>
		<xsl:text>]</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		
	</xsl:template>
	
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
	
	<!-- create symbolic link -->
	<xsl:template match="file[@target]" mode="text">
		<xsl:variable name="targetFile" select="concat($outpath, '/', @target)"/>
			<!--<xsl:choose>
				<xsl:when test="@relative = 'true'"><xsl:value-of select="@target"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($outpath, '/', @target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		<xsl:variable name="symbolicLink" select="concat($outpath, '/', @link)"/>
		<xsl:variable name="createLink" select="java:org.metanorma.Util.createSymbolicLink($targetFile, $symbolicLink, @folder = 'true', @relative = 'true')"/>
	</xsl:template>
	
	<!-- copy file from stepmod2mn.jar -->
	<xsl:template match="file[@resource]" mode="text">
		<xsl:variable name="targetFile" select="concat($outpath, '/', @path)"/>
		<xsl:variable name="createLink" select="java:org.metanorma.Util.copyFileFromResource(@resource, $targetFile)"/>
	</xsl:template>
	
	<!-- copy file -->
	<xsl:template match="file[@source]" mode="text">
		<xsl:variable name="sourceFile" select="concat($path, '/', @source)"/>
		<xsl:variable name="targetFile" select="concat($outpath, '/', @path)"/>
		<xsl:variable name="copyFile" select="java:org.metanorma.Util.copyFile($sourceFile, $targetFile)"/>
	</xsl:template>
	
	<xsl:template match="file[@empty = 'true']" mode="text"/>
	
	<xsl:template match="ExternalDocumentReference" mode="text">
		<!-- <xsl:text>&lt;&lt;</xsl:text>
		
		<xsl:choose>
			<xsl:when test="starts-with(@docid, '/resources/')">
				<xsl:value-of select="substring-after(@docid, '/resources/')"/>
			</xsl:when>
			<xsl:when test="starts-with(@docid, '/resource_docs/')">
				<xsl:value-of select="substring-after(@docid, '/resource_docs/')"/>
			</xsl:when>				
			<xsl:otherwise>
				<xsl:value-of select="@docid"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="normalize-space(@anchor) != ''">
			<xsl:text>,#</xsl:text><xsl:value-of select="@anchor"/>
		</xsl:if> -->
		
		<!--
		schema ("." (prefix ".")* label)?
		"action_schema.functions.type1" has 
		schema = action_schema, 
		prefix = functions, 
		label = type1.
		-->
		
		<!-- <<express:action-schema:functions.type1,type1>> -->
		
		<!-- <<draughting,#draughting_element_schema.dimension_curve_directed_callout>> 
		<<express:draughting_element_schema:dimension_curve_directed_callout, dimension_curve_directed_callout>> -->
		
		<xsl:variable name="schema_">
			<xsl:if test="contains(@anchor, '.')">
				<xsl:value-of select="substring-before(@anchor, '.')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="schema" select="normalize-space($schema_)"/>
		
		<!-- <xsl:variable name="prefix_label_">
			<xsl:if test="contains(@anchor, '.')">
				<xsl:value-of select="substring-after(@anchor, '.')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="prefix_label" select="normalize-space($prefix_label_)"/> -->
		
		<xsl:variable name="schema_prefix_label" select="@anchor" />
		
		<!-- <xsl:variable name="label_">
			<xsl:if test="contains(@anchor, '.')">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="@anchor"/>
					<xsl:with-param name="delimiter" select="'.'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="label" select="normalize-space($label_)"/> -->
		<xsl:variable name="label" select="normalize-space(@anchor)"/>
		
		<!-- 'express:' commented, see https://github.com/metanorma/stepmod2mn/issues/57 -->
		<!-- <xsl:text>&lt;&lt;express:</xsl:text> -->
		<xsl:text>&lt;&lt;</xsl:text>
		<!-- <xsl:if test="$schema != ''"><xsl:value-of select="$schema"/>:</xsl:if> -->
		<xsl:value-of select="$schema_prefix_label"/>
		<xsl:if test="$label != ''">, <xsl:value-of select="$label"/></xsl:if>
		<xsl:text>&gt;&gt;</xsl:text>
	</xsl:template>
	
	
	<xsl:template name="insertBoilerplate">
		<xsl:param name="aname"/>
		<xsl:param name="folder"/>
		<xsl:param name="identifier"/>
		<xsl:param name="text"/>
		<xsl:param name="file"/>
    <xsl:choose>
      <xsl:when test="normalize-space($text) != '' or normalize-space($file) != ''">
        <xsl:text>[</xsl:text><xsl:value-of select="$folder"/><xsl:text>:</xsl:text><xsl:value-of select="$identifier"/><xsl:text>]</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:copy-of select="$text"/>
        <xsl:if test="normalize-space($file) != ''">
          <xsl:copy-of select="java:org.metanorma.Util.getFileContent(concat($boilerplate_path, $file))"/>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>[end_</xsl:text><xsl:value-of select="$folder"/><xsl:text>]</xsl:text>
        <xsl:text>&#xa;&#xa;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
				<xsl:variable name="for_name">
					<xsl:if test="$aname != ''">for '<xsl:value-of select="$aname"/>'</xsl:if>
				</xsl:variable>
        <xsl:message>[ERROR] boilerplate text <xsl:value-of select="$for_name"/> is empty.</xsl:message>
        <!-- <xsl:text>&#xa;&#xa;</xsl:text> -->
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>
	
	<xsl:template match="b" mode="text">
      <xsl:variable name="element">
         <xsl:call-template name="processUnconstrainedFormatting"/>
      </xsl:variable>
		<!-- element=<xsl:copy-of select="$element"/> -->
      <xsl:choose>
         <xsl:when test="xalan:nodeset($element)/*[local-name() = 'b']">
            <xsl:text>*</xsl:text><xsl:apply-templates mode="text"/><xsl:text>*</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="xalan:nodeset($element)" mode="text"/>
         </xsl:otherwise>
      </xsl:choose>
	</xsl:template>
	<xsl:template match="b2" mode="text">
		<xsl:text>**</xsl:text><xsl:apply-templates mode="text"/><xsl:text>**</xsl:text>
	</xsl:template>
	
	<xsl:template match="i" mode="text">
		<xsl:variable name="element">
         <xsl:call-template name="processUnconstrainedFormatting"/>
      </xsl:variable>
		<xsl:choose>
         <xsl:when test="xalan:nodeset($element)/*[local-name() = 'i']">
            <xsl:text>_</xsl:text><xsl:apply-templates mode="text"/><xsl:text>_</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="xalan:nodeset($element)" mode="text"/>
         </xsl:otherwise>
      </xsl:choose>
	</xsl:template>
	<xsl:template match="i2" mode="text">
		<xsl:text>__</xsl:text><xsl:apply-templates mode="text"/><xsl:text>__</xsl:text>
	</xsl:template>
	
	<xsl:template match="tt" mode="text">
		<xsl:variable name="element">
         <xsl:call-template name="processUnconstrainedFormatting"/>
      </xsl:variable>
		<xsl:choose>
         <xsl:when test="xalan:nodeset($element)/*[local-name() = 'tt']">
            <xsl:text>`</xsl:text><xsl:apply-templates mode="text"/><xsl:text>`</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="xalan:nodeset($element)" mode="text"/>
         </xsl:otherwise>
      </xsl:choose>
	</xsl:template>
	<xsl:template match="tt2" mode="text">
		<xsl:text>``</xsl:text><xsl:apply-templates mode="text"/><xsl:text>``</xsl:text>
	</xsl:template>
	
	<xsl:template match="sub" mode="text">
		<xsl:variable name="element">
         <xsl:call-template name="processUnconstrainedFormatting"/>
      </xsl:variable>
		<xsl:choose>
         <xsl:when test="xalan:nodeset($element)/*[local-name() = 'sub']">
            <xsl:text>~</xsl:text><xsl:apply-templates mode="text"/><xsl:text>~</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="xalan:nodeset($element)" mode="text"/>
         </xsl:otherwise>
      </xsl:choose>
	</xsl:template>
	<xsl:template match="sub2" mode="text">
		<!-- <xsl:text>~~</xsl:text><xsl:apply-templates mode="text"/><xsl:text>~~</xsl:text> -->
		<!-- https://github.com/metanorma/stepmod2mn/issues/67 -->
		<xsl:text>~</xsl:text><xsl:apply-templates mode="text"/><xsl:text>~</xsl:text>
	</xsl:template>
	
	<xsl:template match="sup" mode="text">
		<xsl:variable name="element">
         <xsl:call-template name="processUnconstrainedFormatting"/>
      </xsl:variable>
		<xsl:choose>
         <xsl:when test="xalan:nodeset($element)/*[local-name() = 'sup']">
            <xsl:text>^</xsl:text><xsl:apply-templates mode="text"/><xsl:text>^</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="xalan:nodeset($element)" mode="text"/>
         </xsl:otherwise>
      </xsl:choose>
	</xsl:template>
	<xsl:template match="sup2" mode="text">
		<!-- https://github.com/metanorma/stepmod2mn/issues/67 -->
		<!-- <xsl:text>^^</xsl:text><xsl:apply-templates mode="text"/><xsl:text>^^</xsl:text> -->
		<xsl:text>^</xsl:text><xsl:apply-templates mode="text"/><xsl:text>^</xsl:text>
	</xsl:template>
	
	<xsl:template match="br" mode="text">
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="text()[not(ancestor::blockquote or ancestor::code or ancestor::screen or ancestor::li_label or ancestor::refpath)]" mode="text">
		<xsl:value-of select="java:org.metanorma.RegExEscaping.escapeFormattingCommands(.)"/>
	</xsl:template>
	
	<xsl:template name="repeat">
		<xsl:param name="char" select="'='"/>
		<xsl:param name="count" />
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char" />
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char" />
				<xsl:with-param name="count" select="$count - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>
		
	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->	
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/>
	
	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@colspan" mode="simple-table-colspan"/>
	
	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->
	
	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->		
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]" />
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]" />
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="." />
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1" />
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]" />
												<xsl:copy-of select="node()" />
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]" />
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*" />
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)" />
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow" />

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow" />
		</xsl:apply-templates>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->
	<!-- ===================== -->	
	<!-- ===================== -->	
	
	<xsl:template name="substring-after-last">	
		<xsl:param name="value"/>
		<xsl:param name="delimiter"/>    
		<xsl:choose>
			<xsl:when test="contains($value, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="substring-after($value, $delimiter)" />
					<xsl:with-param name="delimiter" select="$delimiter" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="linearize">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="linearize"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="text()[not(parent::code or parent::screen or parent::mml:* or 
			parent::b or parent::b2 or 
			parent::i or parent::i2 or 
			parent::tt or parent::tt2 or 
			parent::sup or parent::sup2 or 
			parent::sub or parent::sub2 or 
			parent::li_label or 
			preceding-sibling::node()[1][self::li_label])]" mode="linearize">
		<xsl:variable name="text_1" select="translate(., '&#xa;&#x9;', '  ')"/>
		<xsl:variable name="text_2" select="java:replaceAll(java:java.lang.String.new($text_1),'\s+',' ')"/>
		<xsl:call-template name="trimSpaces">
			<xsl:with-param name="text" select="$text_2"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="trimSpaces">
		<xsl:param name="text" select="."/>
		
		<xsl:variable name="text_lefttrim">
			<xsl:choose>
				<xsl:when test="not(preceding-sibling::*)">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'^\s+','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="text_righttrim">
			<xsl:choose>
				<xsl:when test="not(following-sibling::*)">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text_lefttrim),'\s+$','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text_lefttrim"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:value-of select="$text_righttrim"/>
	</xsl:template>

   <xsl:template name="processUnconstrainedFormatting">
		<xsl:variable name="unconstrained_formatting"><xsl:call-template name="is_unconstrained_formatting"/></xsl:variable>
		<!-- unconstrained_formatting=<xsl:value-of select="$unconstrained_formatting"/> -->
		<xsl:choose>
			<xsl:when test="$unconstrained_formatting = 'true'">
				<!-- create element b2, i2, sup2, etc. -->
				<xsl:element name="{local-name()}2">
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates mode="text"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!-- copy 'as is' -->
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

   <!-- https://docs.asciidoctor.org/asciidoc/latest/text/ -->
	<!-- Unconstrained formatting pair -->
	<xsl:template name="is_unconstrained_formatting">
	
		<xsl:variable name="prev_text" select="preceding-sibling::node()[1]"/>
		<xsl:variable name="prev_char" select="substring($prev_text, string-length($prev_text))"/>
		
		<xsl:variable name="next_text" select="following-sibling::node()[1]"/>
		<xsl:variable name="next_char" select="substring($next_text, 1, 1)"/>
		
		<xsl:variable name="text" select="."/>
		<xsl:variable name="first_char" select="substring($text, 1, 1)"/>
		<xsl:variable name="last_char" select="substring($text, string-length($text))"/>
		
		<xsl:choose>
			<!--  a blank space does not precede the text to format -->
			<xsl:when test="$prev_char != '' and $prev_char != ' '">true</xsl:when>
			
			<!-- a blank space or punctuation mark (, ; " . ? or !) does not directly follow the text -->
			<xsl:when test="$next_char != '' and $next_char != ' ' and 
													$next_char != ',' and $next_char != ';' and $next_char != '&quot;' and $next_char != '.' and $next_char != '?' and $next_char != '!'">true</xsl:when>
													
			<!-- text does not start or end with a word character -->
			<xsl:when test="($first_char != '' and java_char:isLetter($first_char) != 'true') or ($last_char != '' and java_char:isLetter($last_char) != 'true')">true</xsl:when>
			
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="generateSchemasYaml">
		<xsl:message>[INFO] Generation schemas.yaml ...</xsl:message>
		<redirect:write file="{$outpath}/schemas.yaml">
			<xsl:text>---</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>schemas:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="resource/schema">
				<xsl:text>  </xsl:text><xsl:value-of select="@name"/><xsl:text>:</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>    path: </xsl:text>
				<!-- generate relative path to the schema's annotated.exp -->
				<!-- current input path: $path -->
				<!-- Step1: calculate full path to '../../resources/',@name,'/',@name,'_annotated.exp' -->
				<!-- Step2: calculate relative path to '../../resources/',@name,'/',@name,'_annotated.exp' from output path -->
				
				<!-- https://github.com/metanorma/stepmod2mn/issues/87 -->
				<!-- <xsl:variable name="schema_annotated_exp_relative_path" select="concat('../../resources/',@name,'/',@name,'_annotated.exp')"/> -->
				<xsl:variable name="schema_annotated_exp_relative_path" select="concat('../../resources/',@name,'/',@name,'.exp')"/>
				<xsl:variable name="schema_annotated_exp_path">
					<xsl:choose>
						<xsl:when test="$outpath_schemas != ''">
							<xsl:value-of select="concat($outpath_schemas,'/',@name,'/',@name,'.exp')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($path, '/', $schema_annotated_exp_relative_path)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- <xsl:variable name="schema_annotated_exp_path" select="concat($path, '/', $schema_annotated_exp_relative_path)"/> -->
				
				<xsl:variable name="schema_annotated_exp_relative_path_new" select="java:org.metanorma.Util.getRelativePath($schema_annotated_exp_path, $outpath)"/>
				<xsl:value-of select="$schema_annotated_exp_relative_path_new"/>
				<xsl:text>&#xa;</xsl:text>
				
				<!-- <xsl:text>    path: </xsl:text>
				<xsl:value-of select="$schema_annotated_exp_relative_path"/>
				<xsl:text>&#xa;</xsl:text> -->
			</xsl:for-each>
		</redirect:write>
	</xsl:template>
	
	<!-- Example:
		directives:
			- documents-inline
		bibdata:
			title:
				- language: en
					content: "Industrial automation systems and integration - - Product data representation and exchange - - Integrated generic resource: Fundamentals of product description and support"
				- language: fr
					content: "Systèmes d'automatisation industrielle et intégration - - Représentation et échange de données de produits - - Ressources génériques intégrées: Principes de description et de support de produits"
			type: collection
			docid:
				type: iso
				id: 10303-41
			edition: 6
			copyright:
				owner:
					name: International Standards Organization
					abbreviation: ISO
				from: 2019
		manifest:
			level: collection
			title: ISO Collection
			manifest:
				- level: document
					title: Document
					docref:
						- fileref: document.xml
							identifier: iso10303-41
							sectionsplit: true
				- level: attachments
					title: Attachments
					docref:
						- fileref: ../../resources/action_schema/action_schema.exp
							identifier: action_schema.exp
							attachment: true
							...
		-->
	<xsl:template name="generateCollectionYaml">
		<xsl:param name="data_element"/>
		<xsl:variable name="data" select="xalan:nodeset($data_element)"/>
		<xsl:message>[INFO] Generation collection.yaml ...</xsl:message>
		<redirect:write file="{$outpath}/collection.yml">
			<xsl:text>directives:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  - documents-inline</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>bibdata:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  title:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:for-each select="$data//title">
				<xsl:text>    - language: </xsl:text><xsl:value-of select="@lang"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>      content: "</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
			<xsl:text>  type: collection</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  docid:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>    type: iso</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>    id: </xsl:text><xsl:value-of select="$data//docid"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  edition: </xsl:text><xsl:value-of select="$data//edition"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  copyright:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>    owner:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>      name: International Standards Organization</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>      abbreviation: ISO</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>    from: </xsl:text><xsl:value-of select="$data//year"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>manifest:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  level: collection</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  title: ISO Collection</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  manifest:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>    - level: document</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>      title: Document</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>      docref:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>        - fileref: document.xml</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>          identifier: iso10303-</xsl:text><xsl:value-of select="$data//part"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>          sectionsplit: true</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>    - level: attachments</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>      title: Attachments</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>      docref:</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:variable name="current_resource_name" select="resource/@name"/>
			<xsl:for-each select="resource/schema">
				<xsl:text>        - fileref: </xsl:text>
				<!-- <xsl:value-of select="concat('../../resources/',@name,'/',@name,'.exp')"/> --> <!-- updated for https://github.com/metanorma/stepmod2mn/issues/49, was ../../../resources/ -->
				
				<xsl:variable name="schema_exp_relative_path" select="concat('../../resources/',@name,'/',@name,'.exp')"/>
				
				<xsl:variable name="schema_exp_exists" select="java:org.metanorma.Util.fileExists(concat($path, '/', $schema_exp_relative_path))"/>
				<xsl:if test="normalize-space($schema_exp_exists) = 'false'">
					<xsl:variable name="msg">[ERROR] File '<xsl:value-of select="$schema_exp_relative_path"/>' does not exist.</xsl:variable>
					<xsl:message><xsl:value-of select="$msg"/></xsl:message>
					<xsl:message>[INFO] Repository index path: <xsl:value-of select="$repositoryIndex_path"/></xsl:message>
					<xsl:if test="$repositoryIndex_path != ''">
						<xsl:if test="count(document($repositoryIndex_path)//resource_doc[@name = $current_resource_name]) = 0">
							<redirect:write file="{$errors_fatal_log_filename}">
								<xsl:value-of select="$msg"/><xsl:text>&#xa;</xsl:text>
							</redirect:write>
						</xsl:if>
					</xsl:if>
				</xsl:if>
        
				<xsl:variable name="schema_exp_path">
					<xsl:choose>
						<xsl:when test="$outpath_schemas != ''">
							<xsl:value-of select="concat($outpath_schemas,'/',@name,'/',@name,'.exp')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($path, '/', $schema_exp_relative_path)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- <xsl:variable name="schema_exp_path" select="concat($path, '/', $schema_exp_relative_path)"/> -->
				<xsl:variable name="schema_exp_relative_path_new" select="java:org.metanorma.Util.getRelativePath($schema_exp_path, $outpath)"/>
				<xsl:value-of select="$schema_exp_relative_path_new"/>
				
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>          identifier: </xsl:text><xsl:value-of select="@name"/><xsl:text>.exp</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>          attachment: true</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
			<xsl:for-each select="resource/schema">
				<xsl:text>        - fileref: </xsl:text><xsl:value-of select="concat('sections/schemadocs/',@name,'.html')"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>          identifier: </xsl:text><xsl:value-of select="@name"/><xsl:text>.html</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>          attachment: true</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</redirect:write>
	</xsl:template>
	
	<xsl:template name="generateHtmlAttachmentsSH">
		<xsl:message>[INFO] Generation html_attachments.sh ...</xsl:message>
		<redirect:write file="{$outpath}/html_attachments.sh">
			<xsl:text>mkdir sections/schemadocs</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>for f in</xsl:text>
			<!-- Example: action_schema application_context_schema approval_schema basic_attribute_schema certification_schema contract_schema date_time_schema document_schema effectivity_schema experience_schema external_reference_schema group_schema language_schema location_schema management_resources_schema measure_schema person_organization_schema product_definition_schema product_property_definition_schema product_property_representation_schema qualifications_schema security_classification_schema support_resource_schema</xsl:text> -->
			<xsl:for-each select="resource/schema">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
			</xsl:for-each>
			
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>do</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  fname="sections/schemadocs/${f}.adoc"</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  cat &lt;&lt; EOF &gt; $fname</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>= X</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>:lutaml-express-index: schemas; schemas.yaml;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>:bare: true</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>:mn-document-class: iso</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>:mn-output-extensions: html</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text></xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>[lutaml, schemas, context, leveloffset=+1]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>---</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>{% for schema in context.schemas %}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>{% if schema.id == "${f}" %}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>{% assign schemaname = schema.id | append: "$" | remove: "_schema$" | remove: "$" | replace: "_", " " | capitalize %}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text></xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>[%unnumbered]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>== {{schemaname }}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text></xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>[source%unnumbered]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>--</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>{{ schema.source }}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>--</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>{% endif %}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>{% endfor %}</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>---</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>EOF</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>done</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text></xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>for f in sections/schemadocs/*.adoc; do</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  local="${f##*/}"</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  cp $f $local</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  echo "compile $f"</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  bundle exec metanorma $local</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  rm $local</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  mv "${local%%.adoc}.html" "sections/schemadocs/${local%%.adoc}.html"</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  mv "${local%%.adoc}.err.html" sections/schemadocs</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>  mv "${local%%.adoc}.presentation.xml" sections/schemadocs</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>done</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</redirect:write>
	</xsl:template>
	
	<!-- <xsl:template name="generateCollectionSH">
		<xsl:param name="partnumber"/>
		<xsl:message>[INFO] Generation collection.sh ...</xsl:message>
		<redirect:write file="{$outpath}/collection.sh">
			<xsl:text>sh ./html_attachments.sh</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>bundle exec metanorma -x xml document.adoc</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>bundle exec metanorma collection collection.yml -x xml,html,presentation -w iso10303</xsl:text>
			<xsl:if test="$partnumber != ''"><xsl:text>-</xsl:text><xsl:value-of select="$partnumber"/></xsl:if>
			<xsl:text>&#xa;</xsl:text>
		</redirect:write>
	</xsl:template> -->
	
	<!-- for debug purposes -->
	<xsl:template match="*" mode="print_as_xml">
		<xsl:text>&#xa;&lt;</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		
		<xsl:for-each select="namespace::*">
			<xsl:text> xmlns</xsl:text>
			<xsl:variable name="xmlns_name" select="local-name()"/>
			<xsl:if test="$xmlns_name != ''">:<xsl:value-of select="$xmlns_name"/></xsl:if>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="print_as_xml"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	
</xsl:stylesheet>