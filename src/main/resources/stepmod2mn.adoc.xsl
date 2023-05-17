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
		<xsl:variable name="lang" select="java:toLowerCase(java:java.lang.String.new(resource/@language))"/>
		<xsl:choose>
			<xsl:when test="$lang = 'e'">en</xsl:when> 
			<xsl:when test="$lang = 'd'">de</xsl:when> 
			<xsl:when test="$lang = 'z'">zh</xsl:when> 
			<xsl:otherwise><xsl:value-of select="resource/@language"/></xsl:otherwise>
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
			<xsl:variable name="index_term" select="concat(' (((', $header,  ',term)))')"/>
			<xsl:value-of select="$index_term"/>
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
			<xsl:when test="$keep-with-previous = 'true'">+<br/>+<br/></xsl:when>
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
		
		<br/><br/>
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
				<xsl:value-of select="$href"/><xsl:text>[</xsl:text><xsl:value-of select="normalize-space(xalan:nodeset($a)/*/text())"/><xsl:text>]</xsl:text>
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
		
		<xsl:variable name="label_">
			<xsl:if test="contains(@anchor, '.')">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="@anchor"/>
					<xsl:with-param name="delimiter" select="'.'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="label" select="normalize-space($label_)"/>
		
		<xsl:text>&lt;&lt;express:</xsl:text>
		<!-- <xsl:if test="$schema != ''"><xsl:value-of select="$schema"/>:</xsl:if> -->
		<xsl:value-of select="$schema_prefix_label"/>
		<xsl:if test="$label != ''">, <xsl:value-of select="$label"/></xsl:if>
		<xsl:text>&gt;&gt;</xsl:text>
	</xsl:template>
	
	
	<xsl:template name="insertBoilerplate">
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
        <xsl:text>Error: boilerplate text is empty.</xsl:text>
        <xsl:text>&#xa;&#xa;</xsl:text>
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
		<xsl:text>~~</xsl:text><xsl:apply-templates mode="text"/><xsl:text>~~</xsl:text>
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
	<xsl:template match="sup" mode="text">
		<xsl:text>^^</xsl:text><xsl:apply-templates mode="text"/><xsl:text>^^</xsl:text>
	</xsl:template>
	
	<xsl:template match="br" mode="text">
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="text()[not(ancestor::blockquote or ancestor::code or ancestor::screen or ancestor::li_label)]" mode="text">
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
			parent::sub or parent::sub2)]" mode="linearize">
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
			<xsl:when test="java_char:isLetter($first_char) != 'true' or java_char:isLetter($last_char) != 'true'">true</xsl:when>
			
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>