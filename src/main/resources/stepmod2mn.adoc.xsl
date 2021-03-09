<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mml="http://www.w3.org/1998/Math/MathML" 
		xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:xalan="http://xml.apache.org/xalan" 
		xmlns:java="http://xml.apache.org/xalan/java" 
		xmlns:metanorma-class="xalan://com.metanorma.RegExEscaping"
    xmlns:metanorma-class-util="xalan://com.metanorma.Util"
		exclude-result-prefixes="mml tbx xlink xalan java metanorma-class metanorma-class-util" 
		version="1.0">

	

	<xsl:import href="stepmod.base_xsl/common.xsl"/>
	
	<xsl:import href="stepmod.base_xsl/res_doc/common.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_description.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_link.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/expressg_icon.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/resource.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_introduction.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_1_scope.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_2_refs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_3_defs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_schema.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_4_express.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_a_short_names.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_b_obj_reg.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_c_exp_schema.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_code.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_biblio.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_examples.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_tech_discussion.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_add_scope.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_g_change.xsl"/>
	
	
	<xsl:import href="stepmod.base_xsl/projmg/resource_issues.xsl"/>

	<!-- <xsl:output method="xml" encoding="UTF-8"/> -->
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:strip-space elements="*"/>
			
	<xsl:param name="path"/>
  
	<xsl:param name="boilerplate_path"/>
	
	<!-- placeholders, global variables -->
	<xsl:variable name="FILE_EXT" select="'.xml'"/>
	
	<xsl:variable name="menubar_file" select="'menubar_default.xml'"/>

  <!-- If YES, all items in a list are checked to see if they end in ;
       apart from the last one which should end in .
       If not then and error is flagged -->
  <xsl:variable name="ERROR_CHECK_LIST_ITEMS" select="'NO'"/>

  <!-- If YES, will apply checks to attributes -->
  <xsl:variable name="ERROR_CHECK_ATTRIBUTES" select="'NO'"/>


  <!-- If YES, will apply checks to ISO cover page -->
  <xsl:variable name="ERROR_CHECK_ISOCOVER" select="'NO'"/>



  <!-- parameters that control the output -->

  <!-- the name of a cascading stylesheet. If no cascading stylesheets
       are required do set the paramter null -->
  <!-- <xsl:param name="output_css" select="'stepmod.css'"/> -->
  <xsl:variable name="output_css" select="''"/>

  <!-- When YES the Table of schema table of contents will be output -->
  <xsl:variable name="output_toc" select="'YES'"/>

  <!-- When YES the RCS version control information will be output 
       Used by:
       xsl:template match="module" mode="title" in common.xsl
       xsl:template match="module" mode="TOCbannertitle" in common.xsl
       -->
  <xsl:variable name="output_rcs" select="'YES'"/>

  <!-- When 
          'yes' the errors will be displayed in the HTML
          'no' the errors will only be reported as messages.
       Used by:
       xsl:template name="error_message" in common.xsl
       -->
  <xsl:variable name="INLINE_ERRORS" select="'yes'"/>


  <!-- When 
          'yes' the mapping tables will be checked and errors will be
                displayed in the HTML 
          'no'  NO checking is done 
       Turning off mapping checking will speed up display of mapping
       tables as a list of all mim and integrated resources are loaded into
       global variables.      
       Used by:
       sect5_mapping.xsl
       -->
  <xsl:variable name="check_mapping" select="'yes'"/>


  <!-- when YES issues will be read from the issues.xml file stored in the
       module directory -->
  <xsl:variable name="output_issues" select="'NO'"/>


  <!-- when YES modules will have a background image  -->
  <xsl:variable name="output_background" select="'NO'"/>

  <!-- file containing background image  -->
  <xsl:variable name="background_image" select="'refonly.gif'"/>

  <!-- when length is 0, use the rcs date. Otherwise use value of param, as when building -->
  <xsl:variable name="coverpage_date" select="''"/>

  <!-- The path to the modules. This will be overwritten from the
       ballot package generation as the ballots html is stored in
       stepmod/ballots/isohtml/<ballot>/data/modules-->
  <xsl:variable name="STEPMOD_DATA_MODULES" select="'../../../../../stepmod/data/modules/'"/>

  <!-- The path to the resources. This will be overwritten from the
       ballot package generation as the ballots html is stored in
       stepmod/ballots/isohtml/<ballot>/data/resources-->
  <xsl:variable name="STEPMOD_DATA_RESOURCES" select="'../../../../../stepmod/data/resources/'"/>

  <!-- The path to the ap_docs. This will be overwritten from the
       ballot package generation as the ballots html is stored in
       stepmod/ballots/isohtml/<ballot>/data/ap_docs-->
  <xsl:variable name="STEPMOD_DATA_APS" select="'../../../../../stepmod/data/application_protocol/'"/>
  <!--  Ballot build process sets to YES to provide navigation to SC4  cover-->

  <xsl:param name="ballot" select="'NO'"/>
  <!--  Publication  build process sets to YES to provide navigation to ISO  cover-->  
  <xsl:variable name="publication" select="'NO'"/>

<!-- When YES, ballot is confirmatory so special paragraph is included  in the sc4 cover sheet -->
  <xsl:variable name="confirmatory_ballot" select="'NO'"/>


	<xsl:variable name="view" select="'repository'"/>

	<xsl:variable name="current_module" select="/resource/@name"/>
	
	<!-- resource.xml -->
	<xsl:template match="/">

		<xsl:text>:docnumber: </xsl:text><xsl:apply-templates select="resource" mode="docnumber"/> <!-- res_doc/sect_1_scope.xsl -->
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:partnumber: </xsl:text><xsl:value-of select="resource/@part"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:edition: </xsl:text><xsl:value-of select="resource/@version"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:title-intro-en: Industrial automation systems and integration</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-main-en: Product data representation and exchange</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-part-en: </xsl:text><xsl:apply-templates select="resource" mode="display_name"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-intro-fr: Systèmes d'automatisation industrielle et intégration</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-main-fr: Représentation et échange de données de produits </xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-part-fr: </xsl:text><xsl:apply-templates select="resource" mode="display_name_french"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:doctype: international-standard</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:apply-templates select="resource" mode="docstage"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:copyright-year: </xsl:text><xsl:value-of select="substring(resource/@publication.year,1,4)"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:variable name="keywords">			
			<xsl:apply-templates select="resource/keywords"/>
		</xsl:variable>
		<xsl:if test="normalize-space($keywords) != ''">
			<xsl:text>:keywords: </xsl:text><xsl:value-of select="normalize-space($keywords)"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>

		<!-- fixed text from resource.xml   <xsl:template match="resource" mode="coverpage"> -->
		
		<xsl:text>:technical-committee-number: 184</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:subcommittee-number: 4</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:workgroup-number: 12</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:library-ics: 25.040.40</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		
		
		<xsl:variable name="adoc">
	
			<!-- Abstract -->
			<xsl:message>[INFO] Processing Abstract ...</xsl:message>
			<xsl:apply-templates select="resource" mode="abstract"/> <!-- res_doc/resource.xsl  -->

			
			<!-- Foreword-->
			<!-- draughting_elements/sys/foreword.xml -->
			<xsl:message>[INFO] Processing Foreword ...</xsl:message>
			<xsl:apply-templates select="resource" mode="foreword"/> <!-- res_doc/resource.xsl  -->
			
			<!-- Introduction -->
			<!-- draughting_elements/sys/introduction.xml -->
			<xsl:message>[INFO] Processing Introduction ...</xsl:message>
			<xsl:apply-templates select="resource" mode="introduction"/> <!-- res_doc/sect_introduction.xsl  -->
					
			<!-- 1 Scope -->
			<!-- draughting_elements/sys/1_scope.xml -->
			<xsl:message>[INFO] Processing Scope ...</xsl:message>
			<xsl:apply-templates select="resource" mode="scope_resource"/>	<!-- res_doc/sect_1_scope.xsl  -->	
			
			
			
			
			<!-- 2 Normative references -->
			<!-- sys/2_refs.xml -->
			<xsl:message>[INFO] Processing Normative references ...</xsl:message>		
			<xsl:apply-templates select="resource" mode="norm_refs_resource"/> <!-- res_doc/sect_2_refs.xsl  -->
			
			
			<!-- 3 Terms, definitions and abbreviated terms -->
			<!-- sys/3_defs.xml -->
			<!-- 3.1 Terms and definitions -->
			<!-- 3.2 Abbreviated terms -->
			<xsl:message>[INFO] Processing Terms, definitions and abbreviated terms ...</xsl:message>		
			<xsl:apply-templates select="resource" mode="terms_definitions_resource"/> <!-- res_doc/sect_3_defs.xsl -->
			
			<!-- optional section -->
			<!--- 4 EXPRESS short listing -->
			<!-- 4.1 General -->
			<!-- 4.2 Fundamental concepts and assumptions -->
			<!-- 4.3 Draughting elements entity definitions -->		
			<xsl:for-each select="resource/schema">
				<xsl:variable name="schema_pos" select="position()"/>
				<xsl:message>[INFO] Processing Section <xsl:value-of select="$schema_pos + 3"/> ...</xsl:message>
				<xsl:apply-templates select="../../resource" mode="schema_resource"> <!-- res_doc/sect_schema.xsl -->
					 <xsl:with-param name="pos" select="$schema_pos"/>
				 </xsl:apply-templates>		
			</xsl:for-each>
			
			<!-- Annex A Short names of entities -->
			<xsl:message>[INFO] Processing Annex A Short names of entities ...</xsl:message>		
			<xsl:apply-templates select="resource" mode="annex_a"/> <!-- res_doc/sect_a_short_names.xsl  -->
			
			<!-- Annex B Information object registration -->
			<xsl:message>[INFO] Processing Annex B Information object registration ...</xsl:message>		
			<xsl:apply-templates select="resource" mode="annex_b"/> <!-- res_doc/sect_b_obj_reg.xsl  -->

			<!-- Annex C Computer interpretable listings -->
			<xsl:message>[INFO] Processing Annex C Computer interpretable listings ...</xsl:message>		
			<xsl:apply-templates select="resource" mode="annexc"/> <!-- res_doc/sect_c_exp.xsl  -->
			
			<!-- Annex D EXPRESS-G diagrams -->
			<xsl:message>[INFO] Processing Annex D EXPRESS-G diagrams ...</xsl:message>		
			<xsl:apply-templates select="resource" mode="annexd"/> <!-- res_doc/sect_d_expg.xsl  -->
				
			<!-- Annex E F G H -->		
			
			<!-- Annex Technical discussion -->		
			<xsl:if test="string-length(normalize-space(resource/tech_discussion//text())) &gt; 0">			
				<xsl:message>[INFO] Processing Annex Technical discussion ...</xsl:message>		
				<xsl:apply-templates select="resource" mode="tech_discussion"/> <!-- res_doc/sect_tech_discussion.xsl -->
			</xsl:if>
			
			<!-- Annex Examples -->
			<xsl:if test="string-length(normalize-space(resource/examples//text())) &gt; 0">			
				<xsl:message>[INFO] Processing Annex Examples ...</xsl:message>		
				<xsl:apply-templates select="resource" mode="examples"/> <!-- res_doc/sect_examples.xsl -->
			</xsl:if>
				
			<!-- Annex Additional scope -->
			<xsl:if test="string-length(normalize-space(resource/add_scope//text())) &gt; 0">
				<xsl:message>[INFO] Annex Additional scope ...</xsl:message>		
				<xsl:apply-templates select="resource" mode="additional_scope"/> <!-- res_doc/sect_add_scope.xsl -->
			</xsl:if>
			
			<!-- Annex x Change history -->
			<xsl:if test="resource/changes">
				<xsl:message>[INFO] Processing Annex Change history ...</xsl:message>		
				<xsl:apply-templates select="resource" mode="change_history"/> <!-- res_doc/sect_g_change.xsl -->
			</xsl:if>
	
		</xsl:variable>
		
		<!-- <xsl:copy-of select="$adoc"/> -->
	
		<xsl:apply-templates select="xalan:nodeset($adoc)" mode="text"/>
		
		
			
		<!-- Bibliography -->
		<xsl:if test="resource/bibliography/*">
			<xsl:message>[INFO] Processing Bibliography ...</xsl:message>		
				<xsl:apply-templates select="resource" mode="bibliography"/> <!-- res_doc/sect_biblio.xsl  -->	
		</xsl:if>
		
		<!-- insert header, if there isn't bibliography in the document, but there are external docs refs -->
		<!-- 
		<xsl:if test="xalan:nodeset($adoc)//ExternalDocumentReference and not(resource/bibliography/*)">
			<xsl:call-template name="insertHeaderADOC">
				<xsl:with-param name="id" select="'bibliography'"/>		
				<xsl:with-param name="level" select="1"/>
				<xsl:with-param name="header" select="'Bibliography'"/>		
			</xsl:call-template>		
		</xsl:if>
	
		<xsl:variable name="ExternalDocumentReferences">
			<xsl:for-each select="xalan:nodeset($adoc)//ExternalDocumentReference">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:for-each select="xalan:nodeset($ExternalDocumentReferences)//ExternalDocumentReference">	
			<xsl:if test="not(preceding-sibling::ExternalDocumentReference/@docid = current()/@docid)">
				<xsl:text>* [[[</xsl:text>
				<xsl:variable name="docid">
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
			</xsl:variable>
			<xsl:value-of select="$docid"/>			
				<xsl:text>,repo:(current-metanorma-collection/</xsl:text>
				<xsl:value-of select="$docid"/>
				<xsl:text>)]]]</xsl:text>
				<xsl:text>, _</xsl:text>
				
				<xsl:variable name="title">
					<xsl:choose>
						<xsl:when test="starts-with(@docid, '/resources/')">
							<xsl:variable name="xmlfile" select="concat(substring-after(@docid, '/resources/'), '.xml')"/>				
							<xsl:value-of select="document(concat($path, '../..', @docid, '/', $xmlfile))//*[@name and not(local-name() = 'application')][1]/@name"/>
						</xsl:when>
						<xsl:when test="starts-with(@docid, '/resource_docs/')">
							<xsl:variable name="xmlfile" select="'resource.xml'"/>				
							<xsl:value-of select="document(concat($path, '../..', @docid, '/', $xmlfile))/*/@name"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:call-template name="module_display_name">
					<xsl:with-param name="module" select="$title"/>
				</xsl:call-template>
				
				<xsl:text>_</xsl:text>
				<xsl:text>&#xa;&#xa;</xsl:text>
			</xsl:if>
		</xsl:for-each>
		-->
		
	</xsl:template>



	<xsl:template name="insertHeaderADOC">
		<xsl:param name="id"/>
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
		<!-- <xsl:value-of select="normalize-space($text)"/> -->
		<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
		<xsl:text>&#xa;&#xa;</xsl:text>
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
		<xsl:param name="text"/>
		<xsl:param name="isolated" select="'true'"/>
		<!-- <xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text> -->
		<br/><br/>
		<xsl:if test="normalize-space($id) != ''">
			<xsl:text>[[</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<!-- <xsl:text>&#xa;</xsl:text> -->
			<br/>
		</xsl:if>      
		<xsl:text>NOTE: </xsl:text><xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/><!-- <xsl:value-of select="normalize-space($text)"/> -->
		<!-- <xsl:text>&#xa;</xsl:text> -->
		<br/>
		<xsl:if test="$isolated = 'true'">
			<!-- <xsl:text>&#xa;</xsl:text> -->
			<br/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertExample">
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		<!-- <xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text> -->
		<br/><br/>
		<xsl:text>[example]</xsl:text>
		<!-- <xsl:text>&#xa;</xsl:text> -->
		<br/>
		<xsl:if test="normalize-space($id) != ''">
			<xsl:text>[[</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>]]</xsl:text>
			<!-- <xsl:text>&#xa;</xsl:text> -->
			<br/>
		</xsl:if>      
		<!-- <xsl:value-of select="normalize-space($text)"/> -->
		<xsl:apply-templates select="xalan:nodeset($text)" mode="linearize"/>
		<!-- <xsl:text>&#xa;&#xa;</xsl:text> -->
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
		<xsl:text>--</xsl:text>
		<xsl:text>&#xa;</xsl:text>		
	</xsl:template>
	
	<xsl:template name="insertNoteQuoteEnd">
		<xsl:text>--</xsl:text>
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
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:text>[lutaml_source,express]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template name="insertCodeEnd">
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>		
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
          <xsl:copy-of select="java:com.metanorma.Util.getFileContent(concat($boilerplate_path, $file))"/>
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
		<xsl:text>*</xsl:text><xsl:apply-templates mode="text"/><xsl:text>*</xsl:text>
	</xsl:template>
	<xsl:template match="b2" mode="text">
		<xsl:text>**</xsl:text><xsl:apply-templates mode="text"/><xsl:text>**</xsl:text>
	</xsl:template>
	
	<xsl:template match="i" mode="text">
		<xsl:text>_</xsl:text><xsl:apply-templates mode="text"/><xsl:text>_</xsl:text>
	</xsl:template>
	<xsl:template match="i2" mode="text">
		<xsl:text>__</xsl:text><xsl:apply-templates mode="text"/><xsl:text>__</xsl:text>
	</xsl:template>
	
	<xsl:template match="tt" mode="text">
		<xsl:text>`</xsl:text><xsl:apply-templates mode="text"/><xsl:text>`</xsl:text>
	</xsl:template>
	<xsl:template match="tt2" mode="text">
		<xsl:text>``</xsl:text><xsl:apply-templates mode="text"/><xsl:text>``</xsl:text>
	</xsl:template>
	
	<xsl:template match="sub" mode="text">
		<xsl:text>~</xsl:text><xsl:apply-templates mode="text"/><xsl:text>~</xsl:text>
	</xsl:template>
	<xsl:template match="sub2" mode="text">
		<xsl:text>~~</xsl:text><xsl:apply-templates mode="text"/><xsl:text>~~</xsl:text>
	</xsl:template>
	
	<xsl:template match="sup" mode="text">
		<xsl:text>^</xsl:text><xsl:apply-templates mode="text"/><xsl:text>^</xsl:text>
	</xsl:template>
	<xsl:template match="sup" mode="text">
		<xsl:text>^^</xsl:text><xsl:apply-templates mode="text"/><xsl:text>^^</xsl:text>
	</xsl:template>
	
	<xsl:template match="br" mode="text">
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="text()[not(ancestor::blockquote or ancestor::code or ancestor::screen or ancestor::li_label)]" mode="text">
		<xsl:value-of select="java:com.metanorma.RegExEscaping.escapeFormattingCommands(.)"/>
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

	
</xsl:stylesheet>