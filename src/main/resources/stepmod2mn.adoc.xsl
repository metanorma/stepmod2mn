<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mml="http://www.w3.org/1998/Math/MathML" 
		xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:xalan="http://xml.apache.org/xalan" 
		xmlns:java="http://xml.apache.org/xalan/java" 
		exclude-result-prefixes="mml tbx xlink xalan java" 
		version="1.0">

	

	<xsl:import href="stepmod.base_xsl/common.xsl"/>
	
	<xsl:import href="stepmod.base_xsl/res_doc/common.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_description.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_link.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/expressg_icon.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/res_toc.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/resource.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_introduction.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_1_scope.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_2_refs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_3_defs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_schema.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_4_express.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_a_short_names.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_b_obj_reg.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_biblio.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_examples.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_tech_discussion.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_add_scope.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_g_change.xsl"/>
	
	
	<xsl:import href="stepmod.base_xsl/projmg/resource_issues.xsl"/>

	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:strip-space elements="*"/>
			
	<xsl:param name="path"/>
	
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
	
	
	<!-- resource.xml -->
	<xsl:template match="/">
		<!-- <xsl:value-of select="$path"/> -->
		
		<!-- Get info from resource.xml -->
		<xsl:text>:docnumber: </xsl:text><xsl:apply-templates select="resource" mode="title"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:docnumber: </xsl:text><xsl:apply-templates select="resource" mode="docnumber"/>
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
		
		
		
		<!-- <xsl:template match="resource" mode="TOCmultiplePage"> -->
		<!-- Copyright -->
		<!-- <xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/cover.xml')))">
			<xsl:message>[INFO] Processing cover.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/cover.xml'))" mode="cover"/>
		</xsl:if> -->
		
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
			
		<!-- Bibliography -->
		<xsl:if test="resource/bibliography/*">
			<xsl:message>[INFO] Processing Bibliography ...</xsl:message>		
				<xsl:apply-templates select="resource" mode="bibliography"/> <!-- res_doc/sect_biblio.xsl  -->	
		</xsl:if>
		
	</xsl:template>



	<xsl:template name="insertHeaderADOC">
		<xsl:param name="id"/>
		<xsl:param name="level" select="1"/>
		<xsl:param name="header"/>		
		<xsl:param name="annex_no"/>		
		<xsl:param name="obligation"/>
		
		<xsl:choose>
			<xsl:when test="$annex_no != ''">
				<xsl:text>[[Annex</xsl:text>
				<xsl:value-of select="$annex_no"/>
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
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>


	<xsl:template name="insertParagraph">
		<xsl:param name="text"/>
		<xsl:value-of select="normalize-space($text)"/>
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>


	<xsl:template name="insertULitem">
		<xsl:param name="text"/>
		<xsl:text>* </xsl:text>
		<xsl:value-of select="normalize-space($text)"/>
		<xsl:text>&#xa;&#xa;</xsl:text>
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
	
	<xsl:template match="table[@type = 'abbreviations'] | table[.//tr[not(count(td) &lt; 2 or count(td) &gt; 2)]]" mode="stepmod2mn">
		<xsl:apply-templates mode="table_dl"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	<!-- <xsl:template match="node()|*" mode="table_dl">
		<xsl:apply-templates mode="table_dl"/>
	</xsl:template> -->
	
	<xsl:template match="tr" mode="table_dl">
		<xsl:apply-templates mode="table_dl"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template match="td" mode="table_dl">
		<xsl:apply-templates mode="stepmod2mn"/>
		<xsl:if test="not(preceding-sibling::td)">
			<xsl:text>:: </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertListItemLabel">
		<xsl:param name="list-label" select="'*'"/>
		<xsl:variable name="level_" select="count(ancestor-or-self::ul) + count(ancestor-or-self::ol)"/>		
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="$level_ = 0">1</xsl:when>
				<xsl:otherwise><xsl:value-of select="$level_"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="$list-label"/>
			<xsl:with-param name="count" select="$level"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="text()" mode="stepmod2mn">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	
	<!-- <xsl:template match="sec/text() | li/text() | ul/text() | ol/text() | inscope/text() | outscope/text()">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template> -->
	
	
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
	
	
	<xsl:template name="insertCodeStart">
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:text>[source]</xsl:text>		
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template name="insertCodeEnd">
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>--</xsl:text>		
		<xsl:text>&#xa;&#xa;</xsl:text>	
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


</xsl:stylesheet>