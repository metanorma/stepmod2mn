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
	
	<xsl:import href="stepmod.base_xsl/express.xsl"/>
	<xsl:import href="stepmod.base_xsl/express_description.xsl"/>
	<xsl:import href="stepmod.base_xsl/express_link.xsl"/>
	<xsl:import href="stepmod.base_xsl/expressg_icon.xsl"/>
	<xsl:import href="stepmod.base_xsl/express_code.xsl"/>
	<xsl:import href="stepmod.base_xsl/module.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_introduction.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_1_scope.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_2_refs.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_3_defs.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_4_express.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_4_info_reqs.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_5_main.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_5_mapping.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_5_mapping_check.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_5_mim.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_6_refdata.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_a_short_names.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_b_obj_reg.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_c_arm_expg.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_d_mim_expg.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_e_exp.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_f_guide.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_g_change.xsl"/>
	<xsl:import href="stepmod.base_xsl/sect_biblio.xsl"/>
  <xsl:import href="stepmod.base_xsl/common/biblio.xsl"/>
  <xsl:import href="stepmod.base_xsl/elt_list.xsl"/>
	
	<xsl:import href="stepmod.base_xsl/projmg/issues.xsl"/>

	<xsl:output method="text" encoding="UTF-8"/> <!-- text, xml for debug -->

	<xsl:strip-space elements="*"/>
			
	<xsl:param name="path"/>
	<xsl:param name="outpath"/>
	<xsl:param name="outpath_schemas"/>
  
	<xsl:param name="boilerplate_path"/>
	<xsl:param name="repositoryIndex_path"/>
	<xsl:param name="errors_fatal_log"/>
	<xsl:param name="errors_fatal_log_filename" select="concat($outpath, '/', $errors_fatal_log)"/>
	
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
	
	<xsl:variable name="imagesdir">images</xsl:variable>
	
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
		
		<xsl:text>:doctype: </xsl:text><xsl:apply-templates select="module" mode="getDocType"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:variable name="docstage">
			<xsl:apply-templates select="module" mode="getDocStage"/>
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
		<xsl:text>:workgroup-number: </xsl:text><xsl:call-template name="get_module_wg_group"/>
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
		
		<!-- commented: https://github.com/metanorma/stepmod2mn/issues/49 -->
		<!-- uncommented: https://github.com/metanorma/stepmod2mn/issues/138 -->
		<xsl:text>:imagesdir: </xsl:text><xsl:value-of select="$imagesdir"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:mn-document-class: iso</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:mn-output-extensions: xml,html,pdf,rxl</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:local-cache-only:</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:data-uri-image:</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:lutaml-express-index: schemas; schemas.yaml;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<!-- Generation schemas.yaml -->
		<xsl:call-template name="generateSchemasYaml"/>
		
		<!-- Generation changes_paths.yaml -->
		<xsl:call-template name="generateChangesPathsYaml"/>
		
		<!-- Generation collection.yml -->
		<!-- <xsl:call-template name="generateCollectionYaml">
			<xsl:with-param name="data_element">
				<data>
					<title lang="en"><xsl:value-of select="$title-intro-en"/> - - <xsl:value-of select="$title-main-en"/> - - <xsl:value-of select="$title-part-en"/></title>
					<title lang="fr"><xsl:value-of select="$title-intro-fr"/> - - <xsl:value-of select="$title-main-fr"/> - - <xsl:value-of select="$title-part-fr"/></title>
					<docid>10303-<xsl:value-of select="module/@part"/></docid>
					<edition><xsl:value-of select="module/@version"/></edition>
					<year><xsl:value-of select="substring(module/@publication.year,1,4)"/></year>
					<part><xsl:value-of select="module/@part"/></part>
				</data>
			</xsl:with-param>
		</xsl:call-template> -->
		
		<xsl:variable name="adoc">
	
			<!-- Abstract -->
      <!-- sys/abstract.xml -->
			<!-- commented, see https://github.com/metanorma/iso-10303-stepmod/issues/33 -->
			<!-- <xsl:message>[INFO] Processing Abstract ...</xsl:message>
			<file path="sections/00-abstract.adoc">
				<xsl:apply-templates select="module" mode="abstract"/> --> <!-- module.xsl  -->
			<!-- </file> -->
			
			<!-- Foreword-->
			<!-- sys/foreword.xml -->
      <xsl:message>[INFO] Processing Foreword ...</xsl:message>
      <file path="sections/00-foreword.adoc">
        <xsl:apply-templates select="module" mode="foreword"/> <!-- module.xsl  -->
      </file>
      
      <!-- Introduction -->
      <!-- sys/introduction.xml -->
      <xsl:message>[INFO] Processing Introduction ...</xsl:message>
      <xsl:variable name="introduction">
        <xsl:apply-templates select="module" mode="introduction"/> <!-- sect_introduction.xsl  -->
      </xsl:variable>
      <xsl:if test="normalize-space($introduction) != ''">
        <file path="sections/00-introduction.adoc">
          <xsl:copy-of select="$introduction"/>
        </file>
      </xsl:if>
          
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
      <xsl:message>[INFO] Processing Information requirements (images only) ...</xsl:message>		
      <!-- note: path_ignore for skip file generation on the disk,
      empty="true" for skip include:: in the document.adoc,
      see https://github.com/metanorma/stepmod2mn/issues/159
      -->
      <file path_ignore="sections/04-info_reqs.adoc" empty="true">
        <xsl:apply-templates select="module" mode="info_reqs_module"/> <!-- sect_4_info_reqs.xsl -->
      </file>
      
      <!-- 5 Module interpreted model -->
      <!-- sys/5_main.xml -->
      <!-- sys/5_mapping.xml -->
      <!-- sys/5_mim.xml -->
      <!-- 5.1 Mapping specification -->
      <!-- 5.2 MIM EXPRESS short listing -->
      <xsl:message>[INFO] Processing Module interpreted model (images only) ...</xsl:message>		
      <file path_ignore="sections/05-mim.adoc" empty="true">
        <xsl:apply-templates select="module" mode="mim_main_module"/> <!-- sect_5_main.xsl  -->
      </file>
      <file path="templates/modules/schemas.adoc" empty="true">
      </file>
      
      <!-- 6 Module reference data -->
      <!-- sys/6_refdata.xml -->
      <xsl:message>[INFO] Processing Module reference data (images only) ...</xsl:message>		
      <file path_ignore="sections/06-refdata.adoc" empty="true">
        <xsl:apply-templates select="module" mode="refdata_module"/> <!-- sect_6_refdata.xsl -->
      </file>
      <file path="templates/modules/module_refdata.adoc" empty="true">
      </file>
      
      <!-- Annex A Short names of entities -->
      <!-- sys/a_short_names.xml -->
      <xsl:message>[INFO] Processing Annex A Short names of entities (images only) ...</xsl:message>		
      <file path_ignore="sections/91-short-names.adoc" empty="true">
        <xsl:apply-templates select="module" mode="annex_a"/> <!-- sect_a_short_names.xsl  -->
      </file>
      <file path="templates/modules/module_annex_short_names.adoc" empty="true">
      </file>
      
      <!-- Annex B Information object registration -->
      <!-- sys/b_obj_reg.xml -->
      <xsl:message>[INFO] Processing Annex B Information object registration (images only) ...</xsl:message>		
      <file path_ignore="sections/92-identifier.adoc" empty="true">
        <xsl:apply-templates select="module" mode="annex_b"/> <!-- sect_b_obj_reg.xsl  -->
      </file>
      <file path="templates/modules/module_annex_identifier.adoc" empty="true">
      </file>

      <!-- Annex C ARM EXPRESS-G -->
      <!-- sys/c_arm_expg.xml -->
      <xsl:message>[INFO] Processing Annex C ARM EXPRESS-G (images only) ...</xsl:message>		
      <file path_ignore="sections/93-arm-express-g.adoc" empty="true">
        <xsl:apply-templates select="module" mode="annex_c"/> <!-- sect_c_arm_expg.xsl -->
      </file>
      <file path="templates/modules/module_annex_diagrams_arm.adoc" empty="true">
      </file>

      <!-- Annex D MIM EXPRESS-G -->
      <!-- sys/d_mim_expg.xml -->
      <xsl:message>[INFO] Processing Annex D MIM EXPRESS-G (images only) ...</xsl:message>		
      <file path_ignore="sections/94-mim-express-g.adoc" empty="true">
        <xsl:apply-templates select="module" mode="annex_d"/> <!-- sect_d_mim_expg.xsl -->
      </file>
      <file path="templates/modules/module_annex_diagrams_mim.adoc" empty="true">
      </file>
      
      <!-- Annex E Computer interpretable listings -->
      <!-- sys/e_exp.xml -->
      <xsl:message>[INFO] Processing Annex E Computer interpretable listings (images only) ...</xsl:message>		
      <file path_ignore="sections/95-listings.adoc" empty="true">
        <xsl:apply-templates select="module" mode="annex_e"/> <!-- sect_e_exp.xsl -->
      </file>
      <file path="templates/modules/module_annex_listings.adoc" empty="true">
      </file>
      
      <!-- Annex F Application module implementation and usage guide -->
      <!-- sys/f_guide.xml -->
      <!-- <xsl:if test="module/usage_guide"> --> <!-- always create Annex F , https://github.com/metanorma/stepmod2mn/issues/143 -->
        <xsl:message>[INFO] Processing Annex F Application module implementation and usage guide ...</xsl:message>		
        
      <!-- https://github.com/metanorma/iso-10303-srl/issues/85:
        If there is no usage guide, use this in document.adoc:
            include::templates/common_files/usage_guide_annex.adoc[]
        If there is usage guide, generate it and use this in document.adoc:
            include::sections/96-usage_guide.adoc[]
      -->
      <xsl:choose>
        <xsl:when test="module/usage_guide">
          <file path="sections/96-usage_guide.adoc">
            <xsl:apply-templates select="module" mode="annex_f"/> <!-- sect_f_guide.xsl -->
          </file>
        </xsl:when>
        <xsl:otherwise>
          <file path="templates/common_files/usage_guide_annex.adoc" empty="true">
        </file>
        </xsl:otherwise>
      </xsl:choose>
      <!-- </xsl:if> -->
      
      <!-- Annex F/G Change history -->
      <!-- sys/g_change -->
      <xsl:if test="module/changes">
        <xsl:message>[INFO] Processing Annex Change history (images only) ...</xsl:message>		
        <file path_ignore="sections/97-change-history.adoc" empty="true">
          <xsl:apply-templates select="module" mode="change_history"/> <!-- sect_g_change.xsl -->
        </file>
        <file path="templates/modules/module_annex_change_history.adoc" empty="true">
        </file>
      </xsl:if>
      
      <!-- create symbolic link to the folder 'templates` in the root of repository -->
      <file link="templates" target="../../templates" folder="true" relative="true"/>
      
      <file link="sections/templates" target="../../templates" folder="true" relative="true"/>
      
    </xsl:variable>
    
    <!-- <xsl:copy-of select="$adoc"/> -->
  
    <xsl:apply-templates select="xalan:nodeset($adoc)" mode="text"/>
    
    <xsl:for-each select="xalan:nodeset($adoc)//file[@path]">
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
	
  <!-- Example:
  - - -
  - changes.yaml
  - schemas/modules/geometric_tolerance/mapping.changes.yaml
  - schemas/modules/geometric_tolerance/arm.changes.yaml
  - schemas/modules/geometric_tolerance/mim.changes.yaml
  -->
  <xsl:template name="generateChangesPathsYaml">
    <xsl:message>[INFO] Generation changes_paths.yaml ...</xsl:message>
		<redirect:write file="{$outpath}/changes_paths.yaml">
			<xsl:text>---</xsl:text>
			<xsl:text>&#xa;</xsl:text>
      <xsl:if test="/module/changes/change/description">
        <xsl:text>- changes.yaml</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
      <xsl:if test="/module/changes/change/mapping.changes">
        <xsl:text>- schemas/modules/</xsl:text><xsl:value-of select="$current_module"/><xsl:text>/mapping.changes.yaml</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
      <xsl:if test="/module/changes/change/arm.changes">
        <xsl:text>- schemas/modules/</xsl:text><xsl:value-of select="$current_module"/><xsl:text>/arm.changes.yaml</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
       <xsl:if test="/module/changes/change/mim.changes">
        <xsl:text>- schemas/modules/</xsl:text><xsl:value-of select="$current_module"/><xsl:text>/mim.changes.yaml</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
      <xsl:if test="/module/changes/change/arm_longform.changes">
        <xsl:text>- schemas/modules/</xsl:text><xsl:value-of select="$current_module"/><xsl:text>/arm_lf.changes.yaml</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
      <xsl:if test="/module/changes/change/mim_longform.changes">
        <xsl:text>- schemas/modules/</xsl:text><xsl:value-of select="$current_module"/><xsl:text>/mim_lf.changes.yaml</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
    </redirect:write>
  </xsl:template>
	
  <!-- Example: 
  - - -
  schemas:
    Geometric_tolerance_arm:
      path: ../../schemas/modules/geometric_tolerance/arm.exp
    Geometric_tolerance_mim:
      path: ../../schemas/modules/geometric_tolerance/mim.exp
  -->
  <xsl:template name="generateSchemasYaml">
    <xsl:message>[INFO] Generation schemas.yaml ...</xsl:message>
    <redirect:write file="{$outpath}/schemas.yaml">
      <xsl:text>---</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>schemas:</xsl:text>
      <xsl:text>&#xa;</xsl:text>
      
      <xsl:variable name="arm_mim_files">
        <file><xsl:value-of select="concat($path, 'arm.xml')"/></file>
        <file><xsl:value-of select="concat($path, 'mim.xml')"/></file>
        <file><xsl:value-of select="concat($path, 'arm_lf.xml')"/></file>
        <file><xsl:value-of select="concat($path, 'mim_lf.xml')"/></file>
      </xsl:variable>
      
      <xsl:for-each select="xalan:nodeset($arm_mim_files)/*">
      
       <xsl:variable name="arm_mim_exp_exists" select="java:org.metanorma.Util.fileExists(.)"/>
       <xsl:if test="normalize-space($arm_mim_exp_exists) = 'true'">
        <xsl:variable name="arm_mim_document" select="document(.)"/>
        <xsl:for-each select="$arm_mim_document/express/schema">
          <xsl:text>  </xsl:text><xsl:value-of select="@name"/><xsl:text>:</xsl:text>
            <xsl:text>&#xa;</xsl:text>
            <xsl:text>    path: </xsl:text>
            
            <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
            <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
            <xsl:variable name="name_lcase" select="translate(@name,$UPPER, $LOWER)"/>
            <xsl:variable name="name">
              <xsl:choose>
                <xsl:when test="contains($name_lcase,'_arm')">
                  <xsl:value-of select="substring-before($name_lcase,'_arm')"/>
                </xsl:when>
                <xsl:when test="contains($name_lcase,'_mim')">
                  <xsl:value-of select="substring-before($name_lcase,'_mim')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$name_lcase"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="arm_or_mim">
              <xsl:choose>
                <xsl:when test="contains($name_lcase,'_arm_lf')">arm_lf</xsl:when>
                <xsl:when test="contains($name_lcase,'_arm')">arm</xsl:when>
                <xsl:when test="contains($name_lcase,'_mim_lf')">mim_lf</xsl:when>
                <xsl:when test="contains($name_lcase,'_mim')">mim</xsl:when>
                <xsl:otherwise><xsl:value-of select="$name_lcase"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- generate relative path to the schema's annotated.exp -->
            <!-- current input path: $path -->
            <!-- Step1: calculate full path to '../../modules/',@name,'/',@name,'_annotated.exp' -->
            <!-- Step2: calculate relative path to '../../modules/',@name,'/',@name,'_annotated.exp' from output path -->
            
            <!-- https://github.com/metanorma/stepmod2mn/issues/87 -->
            <!-- <xsl:variable name="schema_annotated_exp_relative_path" select="concat('../../modules/',@name,'/',@name,'_annotated.exp')"/> -->
            <xsl:variable name="schema_annotated_exp_relative_path" select="concat('../../modules/',$name,'/',$arm_or_mim,'.exp')"/>
            <xsl:variable name="schema_annotated_exp_path">
              <xsl:choose>
                <xsl:when test="$outpath_schemas != ''">
                  <xsl:value-of select="concat($outpath_schemas,'/',$name,'/',$arm_or_mim,'.exp')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat($path, '/', $schema_annotated_exp_relative_path)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="schema_annotated_exp_relative_path_new" select="java:org.metanorma.Util.getRelativePath($schema_annotated_exp_path, $outpath)"/>
            <xsl:value-of select="$schema_annotated_exp_relative_path_new"/>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
       </xsl:if>
      </xsl:for-each>
    </redirect:write>
  </xsl:template>
  
</xsl:stylesheet>