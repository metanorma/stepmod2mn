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

	
	<xsl:import href="stepmod2mn.adoc.xsl"/>

	<xsl:import href="stepmod.base_xsl/common.xsl"/>
	
	<xsl:import href="stepmod.base_xsl/res_doc/common.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_description.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_link.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/expressg_icon.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/express_code.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/module.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_introduction.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_1_scope.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_2_refs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_3_defs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_4_express.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_4_info_reqs.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_5_main.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_5_mapping.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_5_mapping_check.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_5_mim.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_6_refdata.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_a_short_names.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_b_obj_reg.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_c_arm_expg.xsl "/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_d_mim_expg.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_e_exp.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_f_guide.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_g_change.xsl"/>
	<xsl:import href="stepmod.base_xsl/res_doc/sect_biblio.xsl"/>
	
	<xsl:import href="stepmod.base_xsl/projmg/resource_issues.xsl"/>

	<xsl:output method="text" encoding="UTF-8"/> <!-- text, xml for debug -->

	<xsl:strip-space elements="*"/>
			
	<xsl:param name="path"/>
	<xsl:param name="outpath"/>
  
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

	<xsl:variable name="current_module" select="/module/@name"/>
	
	<!-- module.xml -->
	<xsl:template match="/">
		<xsl:variable name="title-intro-en">Industrial automation systems and integration</xsl:variable>
		<xsl:variable name="title-intro-fr">Systèmes d'automatisation industrielle et intégration</xsl:variable>
		<xsl:variable name="title-main-en">Product data representation and exchange</xsl:variable>
		<xsl:variable name="title-main-fr">Représentation et échange de données de produits</xsl:variable>
		<xsl:variable name="title-part-en"><xsl:apply-templates select="module" mode="display_name"/></xsl:variable>
		<xsl:variable name="title-part-fr"><xsl:apply-templates select="module" mode="display_name_french"/></xsl:variable>
		
		<xsl:text>= </xsl:text><xsl:value-of select="$title-main-en"/>: <xsl:value-of select="$title-intro-en"/>: <xsl:value-of select="$title-part-en"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:docnumber: 10303</xsl:text><!-- <xsl:apply-templates select="module" mode="docnumber"/> --><!-- res_doc/sect_1_scope.xsl -->
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:tc-docnumber: </xsl:text><xsl:value-of select="module/@wg.number"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:partnumber: </xsl:text><xsl:value-of select="module/@part"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:copyright-year: </xsl:text><xsl:value-of select="substring(module/@publication.year,1,4)"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:language: </xsl:text><xsl:call-template name="getLanguage"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:publish-date: </xsl:text><xsl:value-of select="module/@publication.date"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:edition: </xsl:text><xsl:value-of select="module/@version"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:title-intro-en: </xsl:text><xsl:value-of select="$title-intro-en"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-intro-fr: </xsl:text><xsl:value-of select="$title-intro-fr"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-main-en: </xsl:text><xsl:value-of select="$title-main-en"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-main-fr: </xsl:text><xsl:value-of select="$title-main-fr"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-part-en: </xsl:text><xsl:value-of select="$title-part-en"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-part-fr: </xsl:text><xsl:value-of select="$title-part-fr"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:doctype: international-standard</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:variable name="docstage">
			<xsl:apply-templates select="module" mode="docstage"/>
		</xsl:variable>
		<xsl:if test="normalize-space($docstage) != ''">
			<xsl:value-of select="$docstage"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		
		<!-- fixed text from module.xml   <xsl:template match="module" mode="coverpage"> -->
		
		<xsl:text>:technical-committee-number: 184</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:technical-committee: Industrial automation systems and integration</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:subcommittee-type: SC</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:subcommittee-number: 4</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:subcommittee: Industrial data</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:workgroup-type: WG</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:workgroup-number: 12</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:secretariat: ANSI</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:variable name="keywords">			
			<xsl:apply-templates select="module/keywords"/>
		</xsl:variable>
		<xsl:if test="normalize-space($keywords) != ''">
			<xsl:text>:keywords: </xsl:text><xsl:value-of select="normalize-space($keywords)"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		
		<xsl:text>:library-ics: 25.040.40</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:imagesdir: images</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:mn-document-class: iso</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:mn-output-extensions: xml,html,doc,pdf,html_alt,rxl</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:local-cache-only:</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:data-uri-image:</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:lutaml-express-index: schemas; schemas.yaml;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:variable name="adoc">
	
			<!-- Abstract -->
      <!-- sys/abstract.xml -->
			<xsl:message>[INFO] Processing Abstract ...</xsl:message>
			<file path="sections/00-abstract.adoc">
				<xsl:apply-templates select="module" mode="abstract"/> <!-- module.xsl  -->
			</file>
			
			<!-- Foreword-->
			<!-- sys/foreword.xml -->
			<xsl:message>[INFO] Processing Foreword ...</xsl:message>
			<file path="sections/00-foreword.adoc">
				<xsl:apply-templates select="module" mode="foreword"/> <!-- module.xsl  -->
			</file>
      
			<!-- Introduction -->
			<!-- sys/introduction.xml -->
			<xsl:message>[INFO] Processing Introduction ...</xsl:message>
			<file path="sections/00-introduction.adoc">
				<xsl:apply-templates select="module" mode="introduction"/> <!-- sect_introduction.xsl  -->
			</file>
					
			<!-- 1 Scope -->
			<!-- sys/1_scope.xml -->
			<xsl:message>[INFO] Processing Scope ...</xsl:message>
			<file path="sections/01-scope.adoc">
				<xsl:apply-templates select="module" mode="scope_module"/>	<!-- sect_1_scope.xsl  -->	
			</file>
			
			
			<!-- 2 Normative references -->
			<!-- sys/2_refs.xml -->
			<xsl:message>[INFO] Processing Normative references ...</xsl:message>		
			<file path="sections/02-norm-refs.adoc">
				<xsl:apply-templates select="module" mode="norm_refs_module"/> <!-- sect_2_refs.xsl  -->
			</file>
			
			
			<!-- 3 Terms, definitions and abbreviated terms -->
			<!-- sys/3_defs.xml -->
			<!-- 3.1 Terms and definitions -->
			<!-- 3.2 Abbreviated terms -->
			<xsl:message>[INFO] Processing Terms, definitions and abbreviated terms ...</xsl:message>		
			<file path="sections/03-terms.adoc">
				<xsl:apply-templates select="module" mode="terms_definitions_module"/> <!-- sect_3_defs.xsl -->
			</file>
			
      <!-- 4 Information requirements -->
      <!-- sys/4_info_reqs.xml -->
      <!-- 4.1 ARM entity definition -->
      <xsl:message>[INFO] Processing Information requirements ...</xsl:message>		
      <file path="sections/04-info_reqs.adoc">
        <xsl:apply-templates select="module" mode="info_reqs_module"/> <!-- sect_4_info_reqs.xsl -->
      </file>
      
      <!-- 5 Module interpreted model -->
      <!-- sys/5_main.xml -->
      <!-- sys/5_mapping.xml -->
      <!-- sys/5_mim.xml -->
      <!-- 5.1 Mapping specification -->
      <!-- 5.2 MIM EXPRESS short listing -->
      <xsl:message>[INFO] Processing Module interpreted model ...</xsl:message>		
      <file path="sections/05-mim.adoc">
        <xsl:apply-templates select="module" mode="mim_main_module"/> <!-- sect_5_main.xsl  -->
      </file>
      
			<!-- 6 Module reference data -->
      <!-- sys/6_refdata.xml -->
			<xsl:message>[INFO] Processing Module reference data ...</xsl:message>		
      <file path="sections/06-refdata.adoc">
        <xsl:apply-templates select="module" mode="refdata_module"/> <!-- sect_6_refdata.xsl -->
      </file>
			
			<!-- Annex A Short names of entities -->
      <!-- sys/a_short_names.xml -->
			<xsl:message>[INFO] Processing Annex A Short names of entities ...</xsl:message>		
			<file path="sections/91-short-names.adoc">
				<xsl:apply-templates select="module" mode="annex_a"/> <!-- sect_a_short_names.xsl  -->
			</file>
			
			<!-- Annex B Information object registration -->
      <!-- sys/b_obj_reg.xml -->
			<xsl:message>[INFO] Processing Annex B Information object registration ...</xsl:message>		
			<file path="sections/92-identifier.adoc">
				<xsl:apply-templates select="module" mode="annex_b"/> <!-- sect_b_obj_reg.xsl  -->
			</file>

      <!-- Annex C ARM EXPRESS-G -->
      <!-- sys/c_arm_expg.xml -->
			<xsl:message>[INFO] Processing Annex C ARM EXPRESS-G ...</xsl:message>		
			<file path="sections/93-arm-express-g.adoc">
				<xsl:apply-templates select="module" mode="annex_c"/> <!-- sect_c_arm_expg.xsl -->
			</file>

      <!-- Annex D MIM EXPRESS-G -->
      <!-- sys/d_mim_expg.xml -->
			<xsl:message>[INFO] Processing Annex D MIM EXPRESS-G ...</xsl:message>		
			<file path="sections/94-mim-express-g.adoc">
				<xsl:apply-templates select="module" mode="annex_d"/> <!-- sect_d_mim_expg.xsl -->
			</file>
      
			<!-- Annex E Computer interpretable listings -->
      <!-- sys/e_exp.xml -->
			<xsl:message>[INFO] Processing Annex E Computer interpretable listings ...</xsl:message>		
			<file path="sections/95-listings.adoc">
				<xsl:apply-templates select="module" mode="annex_e"/> <!-- sect_e_exp.xsl -->
			</file>
      
      <!-- Annex F Application module implementation and usage guide -->
      <!-- sys/f_guide.xml -->
      <xsl:if test="module/usage_guide">
        <xsl:message>[INFO] Processing Annex F Application module implementation and usage guide ...</xsl:message>		
        <file path="sections/96-usage_guide.adoc">
          <xsl:apply-templates select="module" mode="annex_f"/> <!-- sect_f_guide.xsl -->
        </file>
      </xsl:if>
			
			<!-- Annex F/G Change history -->
      <!-- sys/g_change -->
			<xsl:if test="module/changes">
				<xsl:message>[INFO] Processing Annex Change history ...</xsl:message>		
				<file path="sections/97-change-history.adoc">
					<xsl:apply-templates select="module" mode="change_history"/> <!-- sect_g_change.xsl -->
				</file>
			</xsl:if>
      
		</xsl:variable>
		
		<!-- <xsl:copy-of select="$adoc"/> -->
	
		<xsl:apply-templates select="xalan:nodeset($adoc)" mode="text"/>
		
		<xsl:for-each select="xalan:nodeset($adoc)//file">
			<xsl:text>include::</xsl:text><xsl:value-of select="@path"/><xsl:text>[]</xsl:text>
			<xsl:text>&#xa;&#xa;</xsl:text>
		</xsl:for-each>
		
			
		<!-- Bibliography -->
    <!-- sys/biblio.xml -->
		<!-- <xsl:if test="module/bibliography/*"> -->
    <xsl:message>[INFO] Processing Bibliography ...</xsl:message>
    <redirect:write file="{$outpath}/sections/99-bibliography.adoc">
      <xsl:apply-templates select="module" mode="bibliography"/> <!-- res_doc/sect_biblio.xsl  -->	
    </redirect:write>
    <xsl:text>include::sections/99-bibliography.adoc[]</xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text>
		<!-- </xsl:if> -->
		
		
	</xsl:template>
	
</xsl:stylesheet>