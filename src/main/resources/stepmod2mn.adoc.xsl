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
	<xsl:import href="stepmod.base_xsl/res_doc/sect_4_express.xsl"/>
	
	<xsl:import href="stepmod.base_xsl/projmg/resource_issues.xsl"/>

	
	

	<xsl:output method="text" encoding="UTF-8"/>

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
		
		<xsl:text>:part: </xsl:text><xsl:value-of select="resource/@part"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:title-intro-en: Industrial automation systems and integration</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-main-en: Product data representation and exchange</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-part-en: </xsl:text><xsl:apply-templates select="resource" mode="title_part"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:doctype: international-standard</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:apply-templates select="resource" mode="docstage"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:copyright-year: </xsl:text><xsl:value-of select="substring(resource/@publication.year,1,4)"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<!-- 
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
		
		<xsl:text>:docnumber: </xsl:text><xsl:apply-templates select="$resource_xml/resource" mode="title"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:docnumber: </xsl:text><xsl:apply-templates select="$resource_xml/resource" mode="docnumber"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:part: </xsl:text><xsl:value-of select="$resource_xml/resource/@part"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:title-intro-en: Industrial automation systems and integration</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-main-en: Product data representation and exchange</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>:title-part-en: </xsl:text><xsl:apply-templates select="$resource_xml/resource" mode="title_part"/>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>:doctype: international-standard</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:apply-templates select="$resource_xml/resource" mode="doctype"/>
		
		<xsl:choose>
			<xsl:when test="@pos">				
				<xsl:apply-templates select="$resource_xml/resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml/resource"/>
			 </xsl:otherwise>
		 </xsl:choose>
		
		<xsl:text>:copyright-year: </xsl:text><xsl:value-of select="substring($resource_xml/resource/@publication.year,1,4)"/>
		
		-->
		
		
		
		
		<!-- <xsl:template match="resource" mode="TOCmultiplePage"> -->
		<!-- Copyright -->
		<!-- <xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/cover.xml')))">
			<xsl:message>[INFO] Processing cover.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/cover.xml'))" mode="cover"/>
		</xsl:if> -->
		
		
		<!-- Foreword-->
		<!-- draughting_elements/sys/foreword.xml -->
		<xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/foreword.xml')))">
			<xsl:message>[INFO] Processing foreword.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/foreword.xml'))" mode="foreword"/>
		</xsl:if>
		
		<!-- Introduction -->
		<!-- draughting_elements/sys/introduction.xml -->
		<xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/introduction.xml')))">
			<xsl:message>[INFO] Processing introduction.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/introduction.xml'))" mode="introduction"/>
		</xsl:if>
		
		
		
		<!-- 1 Scope -->
		<!-- draughting_elements/sys/1_scope.xml -->
		<xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/1_scope.xml')))">
			<xsl:message>[INFO] Processing scope.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/1_scope.xml'))" mode="scope"/>
		</xsl:if>
		
		<!-- 2 Normative references -->
		<xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/2_refs.xml')))">
			<xsl:message>[INFO] Processing 2_refs.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/2_refs.xml'))" mode="norm_refs"/>
		</xsl:if>
		          
		<!-- 3 Terms, definitions and abbreviated terms -->
		<!-- 3.1 Terms and definitions -->
		<!-- 3.2 Abbreviated terms -->
		<xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/3_defs.xml')))">
			<xsl:message>[INFO] Processing 3_defs.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/3_defs.xml'))" mode="terms_definitions"/>
		</xsl:if>
		
		<!--- 4 EXPRESS short listing -->
    <!-- 4.1 General -->
    <!-- 4.2 Fundamental concepts and assumptions -->
    <!-- 4.3 Draughting elements entity definitions -->
		<xsl:if test=" java:exists(java:java.io.File.new(concat($path, 'sys/4_schema.xml')))">
			<xsl:message>[INFO] Processing 4_schema.xml ...</xsl:message>
			<xsl:apply-templates select="document(concat($path, 'sys/4_schema.xml'))" mode="schema"/>
		</xsl:if>
		
		
	</xsl:template>
	
	
	<!-- =========== -->
	<!--  Foreword -->
	<xsl:template match="resource_clause" mode="foreword">		
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
		<xsl:choose>
			<xsl:when test="@pos">				
				<xsl:apply-templates select="$resource_xml/*" mode="foreword_resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml/*" mode="foreword_resource"/>
			 </xsl:otherwise>
		 </xsl:choose>
	</xsl:template>
	
	<!-- from res_doc/resource.xsl -->

	<!-- END Foreword -->
	<!-- =========== -->
	
	
	<!-- Introduction  -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="introduction">		
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
		<xsl:choose>
			<xsl:when test="@pos">				
				<xsl:apply-templates select="$resource_xml/*" mode="introduction_resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml/*" mode="introduction_resource"/>
			 </xsl:otherwise>
		 </xsl:choose>
	</xsl:template>
	
	<!-- from res_doc\sect_introduction.xsl -->
	<xsl:template match="resource" mode="introduction_resource">
		<xsl:apply-templates select="purpose"/>		
	</xsl:template>
	
	<xsl:template match="purpose">
		<xsl:text>[[introduction]]</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:text>== Introduction</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:text>ISO 10303 is an International Standard for the computer-interpretable representation of product information and for the exchange of product data. The objective is to provide a neutral mechanism capable of describing products throughout their life cycle. This mechanism is suitable not only for neutral file exchange, but also as a basis for implementing and sharing product databases, and as a basis for retention and archiving.</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		
		<xsl:variable name="doctype" >
			<xsl:apply-templates select="ancestor::*[last()]" mode="doctype"/>
		</xsl:variable>
		
		<!-- doctype=<xsl:value-of select="$doctype"/>
		<xsl:text>&#xa;&#xa;</xsl:text> -->
		
		<xsl:choose>
			<xsl:when test="$doctype='igr' or $doctype='iar'">
				<xsl:choose>
					<xsl:when test="count(../schema)>1">
						<xsl:text>Major subdivisions of this part of ISO 10303 are:</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xsl:for-each select="../schema"> 
							<xsl:text>* </xsl:text>
							<xsl:choose>
								<xsl:when test="position()!=last()">
									<xsl:value-of select="concat(@name,';')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat(@name,'.')"/>        
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text>&#xa;&#xa;</xsl:text>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="text">
							This part of ISO 10303 specifies the 
							<xsl:value-of select="../schema[1]/@name" />.
							</xsl:variable>
							<xsl:value-of select="normalize-space($text)"/>
							<xsl:text>&#xa;</xsl:text>						
					</xsl:otherwise>
				</xsl:choose>

				<!-- output any issues -->
				<xsl:apply-templates select=".." mode="output_clause_issue">
					<xsl:with-param name="clause" select="'purpose'"/>
				</xsl:apply-templates>

				<!-- output explicit text from the purpose tag -->
				<xsl:apply-templates/>

				<!-- prepare variables to output list of used schemas and parts -->
				<xsl:text>The relationships of the schemas in this part of ISO 10303 to other schemas that define the integrated resources of ISO 10303 are illustrated in Figure 1 using the EXPRESS-G notation. EXPRESS-G is defined in ISO 10303-11. </xsl:text>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:variable name="used" >
					<xsl:apply-templates select="../schema_diag" mode="use_reference_list" />
				</xsl:variable>
				
				<xsl:apply-templates select="xalan:nodeset($used)/ref-list" />
				

				<xsl:text>The schemas illustrated in Figure 1 are components of the integrated resources.</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:apply-templates select="//schema_diag" />

			</xsl:when>

			<xsl:when test="$doctype='aic'">
				<xsl:text>An application interpreted construct (AIC) provides a logical grouping of interpreted constructs that supports a specific functionality for the usage of product data across multiple application contexts. An interpreted construct is a common interpretation of the integrated resources that supports shared information requirements among application protocols.</xsl:text>
				<xsl:text>&#xa;&#xa;</xsl:text>
				
				<xsl:variable name="text">
					<!-- output explicit text from the purpose tag --> 
					<xsl:apply-templates/>
				</xsl:variable>			
				<xsl:value-of select="normalize-space($text)"/>
				<xsl:text>&#xa;</xsl:text>


			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
		
		
		
		<xsl:text>&#xa;&#xa;</xsl:text>
		
	</xsl:template>

	<!-- from xslt/res_doc/sect_introduction.xsl -->
	<xsl:template match="schema_diag" mode="use_reference_list" >
		<xsl:variable name="local-schemas" select="../schema" />
		<ref-list>
			<xsl:for-each select="express-g/imgfile">
				<xsl:for-each select="document(@file)//img.area[@href]" >
					<xsl:variable name="this-schema" select="substring-after(@href,'#')" />
					<xsl:if test="not($local-schemas[@name=$this-schema])" >    
					<used-schema><xsl:value-of select="$this-schema" /></used-schema>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</ref-list>
	</xsl:template>

	<!-- from xslt/res_doc/sect_introduction.xsl -->
	<xsl:template match="ref-list" >
		<xsl:variable name="used-count" select="count(used-schema[not(.=preceding-sibling::used-schema)])" />
		<xsl:choose>
			<xsl:when test="$used-count = 1" >
				<xsl:variable name="text">
					The <xsl:value-of select="./used-schema[1]" /> shown in Figure 1 is found in 
						<xsl:apply-templates select="./used-schema[1]" mode="reference" />					
				</xsl:variable>
				<xsl:value-of select="normalize-space($text)"/>
			</xsl:when>

			<xsl:when test="$used-count > 1" >
				<xsl:text>The following schemas shown in Figure 1 are not found in this part of ISO 10303, but are found as specified:</xsl:text>
				<xsl:text>&#xa;&#xa;</xsl:text>
				
				<xsl:for-each select="used-schema[not(.=preceding-sibling::used-schema)]">
					<xsl:sort />
					<xsl:text>* </xsl:text>
					<xsl:variable name="text">
						<xsl:value-of select="." /> is found in
						<xsl:apply-templates select="." mode="reference" /> 
						<xsl:choose>
							<xsl:when test="position()!=last()">
								<xsl:value-of select="';'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'.'"/>        
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="$text"/>
					<xsl:text>&#xa;&#xa;</xsl:text>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- from xslt/res_doc/sect_introduction.xsl -->
	<xsl:template match="used-schema" mode="reference" >
		<xsl:variable name="schema-name" select="string(.)" />
		<xsl:variable name="resource_dir">
			<xsl:call-template name="resource_directory">
				<xsl:with-param name="resource" select="$schema-name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="express_xml" select="concat($resource_dir,'/',$schema-name,'.xml')"/>

		<xsl:variable name="ref" select="document($express_xml)/express/@reference"/>

		<xsl:choose>
			<xsl:when test="$ref" >
				<xsl:value-of select="$ref" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('@reference not specified in express entity for resource schema',
			$schema-name)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>	

	</xsl:template>



	<xsl:template match="p">
		<xsl:apply-templates />
		<xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template match="br">
		<xsl:text> +</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template match="b">
		<xsl:text>*</xsl:text><xsl:apply-templates /><xsl:text>*</xsl:text>
	</xsl:template>
	
	<xsl:template match="i">
		<xsl:text>_</xsl:text><xsl:apply-templates /><xsl:text>_</xsl:text>
	</xsl:template>
	
	<xsl:template match="sub">
		<xsl:text>~</xsl:text><xsl:apply-templates /><xsl:text>~</xsl:text>
	</xsl:template>
	
	<xsl:template match="sup">
		<xsl:text>^</xsl:text><xsl:apply-templates /><xsl:text>^</xsl:text>
	</xsl:template>
	
	<xsl:template match="tt">
		<xsl:text>`</xsl:text><xsl:apply-templates /><xsl:text>`</xsl:text>
	</xsl:template>
	
	<xsl:template match="sc">
		<xsl:text>[smallcap]#</xsl:text>
		<xsl:apply-templates />
		<xsl:text>#</xsl:text>
	</xsl:template>
	
	<!-- END Introduction  -->
	<!-- =========== -->
	
	
	<!-- Scope -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="scope">	
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
	
		<xsl:text>== Scope</xsl:text>
		<xsl:text>&#xa;</xsl:text>
	    
		<xsl:choose>
			<xsl:when test="@pos">				
				<xsl:apply-templates select="$resource_xml/*" mode="scope_resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml/*" mode="scope_resource"/>
			 </xsl:otherwise>
		 </xsl:choose>
			
	</xsl:template>
	
	
	<xsl:template match="resource" mode="scope_resource">
		<xsl:variable name="resdoc_name">
			<xsl:call-template name="res_display_name">
			<xsl:with-param name="res" select="@name"/>
			</xsl:call-template>           
		</xsl:variable>

		<xsl:variable name="doctype">
			<xsl:apply-templates select="." mode="doctype"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$doctype='aic'">
					<xsl:text>This part of ISO 10303 specifies the interpretation of the integrated resources to satisfy requirements for the representation of </xsl:text>
					<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($resdoc_name))"/>
					<xsl:text>.</xsl:text>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:when test="$doctype='igr'">
					<xsl:text>This part of ISO 10303 specifies the integrated generic resource constructs for </xsl:text>
					<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($resdoc_name))"/>
					<xsl:text>.</xsl:text>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:when test="$doctype='iar'">
					<xsl:text>This part of ISO 10303 specifies the integrated application resource constructs for </xsl:text>
					<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($resdoc_name))"/>
					<xsl:text>.</xsl:text>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<xsl:apply-templates select="./scope"/>
		<xsl:apply-templates select="./inscope"/>
		<xsl:apply-templates select="./outscope"/>
		
	</xsl:template>
	
	
	<!-- from  sect_1_scope.xsl 	<xsl:template match="resource" mode="special_header"> -->
	<xsl:template match="resource" mode="docnumber">
	  <xsl:choose>
      <xsl:when test="@status='WD' or @status='CD' or @status='DIS'">
        <xsl:value-of select="concat('ISO/',@status,' 10303-',@part)"/>
      </xsl:when>
      <xsl:when test="@status='CD-TS'">
        <xsl:value-of select="concat('ISO/CD TS 10303-',@part)"/>
      </xsl:when>
      <xsl:when test="@status='IS'">
        <xsl:value-of select="concat('ISO',' 10303-',@part,':',@publication.year,'(',@language,')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('ISO/',@status,' 10303-',@part,':',@publication.year,'(',@language,')')"/>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>

	<!-- from  sect_1_scope.xsl 	<xsl:template match="resource" mode="special_header"> -->
	<xsl:template match="resource" mode="docstage">
		<xsl:choose>
			<xsl:when test="@status='WD'">         
				<xsl:text>:docstage: 20</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='CD' or @status='CD-TS'">
				<xsl:text>:docstage: 30</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='DIS'">        
				<xsl:text>:docstage: 40</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='FDIS'">
				<xsl:text>:docstage: 50</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 00</xsl:text>
			</xsl:when>
			<xsl:when test="@status='IS'">
				<xsl:text>:docstage: 60</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: 60</xsl:text>        
			</xsl:when>
			<xsl:when test="@status='TS'">
				<xsl:text>:docstage: ??</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>:docsubstage: ??</xsl:text>        
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	
	
	<!-- END Scope  -->
	<!-- =========== -->
	
	
	
	<!-- Normative References -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="norm_refs">	
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
	    
		<xsl:apply-templates select="$resource_xml/*" mode="norm_refs_resource"/>
		
	</xsl:template>
	
	
	<xsl:template match="resource" mode="norm_refs_resource">
		<xsl:call-template name="output_normrefs">
			<xsl:with-param name="resource_number" select="./@part"/>
			<xsl:with-param name="current_resource" select="."/>
		</xsl:call-template>
	</xsl:template>



	<!-- END Normative References -->
	<!-- ================== -->
	
	
	
	<!-- Terms and Definitions -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="terms_definitions">	
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
	    
		<xsl:apply-templates select="$resource_xml/*" mode="terms_definitions_resource"/>
		
	</xsl:template>
	
	
	<xsl:template match="resource" mode="terms_definitions_resource">
		<xsl:text>[[defns]]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>== Terms, definitions and abbreviated terms</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:text>[[termsdefns]]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>=== Terms and definitions</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:call-template name="output_terms">
			<xsl:with-param name="current_resource" select="."/>
			<xsl:with-param name="resource_number" select="./@part"/>
		</xsl:call-template>

	</xsl:template>

	<!-- END Terms and Definitions -->
	<!-- ================== -->
	
	
	
	<!-- EXPRESS short listing -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="schema">	
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
	  
		<xsl:choose>
			<xsl:when test="@pos">								
				<xsl:apply-templates select="$resource_xml/*" mode="schema_resource">
					 <xsl:with-param name="pos" select="@pos"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml/*" mode="schema_resource"/>
			 </xsl:otherwise>
		 </xsl:choose>
		
	</xsl:template>
	
	
	<!-- global variable - Used by templates in expressg_icon.xsl to
	 resolve href for expressg icon -->
	<xsl:variable name="schema_expressg">
		<xsl:call-template name="make_schema_expressg_node_set"/>
	</xsl:variable>    
	
	<xsl:template match="resource" mode="schema_resource">
		<xsl:param name="pos"/>
		
		
	
		<xsl:apply-templates select="schema[position()=$pos]">
			<xsl:with-param name="pos" select="$pos"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- END EXPRESS short listing -->
	<!-- ================== -->
	
	
	<!-- resource_clause.xsl -->
	<xsl:template match="resource_clause" mode="resource">
		<!-- Ex. <resource_clause directory="draughting_elements"/> -->
		value=<xsl:value-of select="@directory"/>
		<xsl:text>&#xa;</xsl:text>
		
		

		
		<!-- scope -->
		
		
		
		
	</xsl:template>
	


	

	<xsl:template match="resource" mode="title_part">
		<xsl:choose>
			<xsl:when test="@part >  500">Application interpreted construct</xsl:when>
			<xsl:when test="@part >  99">Integrated application resource</xsl:when>
			<xsl:when test="@part &lt;  99">Integrated generic resource</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message" select="concat('Error : unknown type,  part number:', @part)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>: </xsl:text>
		<xsl:call-template name="res_display_name">
			<xsl:with-param name="res" select="@name"/>
		</xsl:call-template>

		
	</xsl:template>



	<xsl:template match="scope/text()">
		<xsl:value-of select="normalize-space(.)"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>



	<xsl:template match="ul/li | li">
		<xsl:call-template name="getLevelListItem">
			<xsl:with-param name="list-label">*</xsl:with-param>
		</xsl:call-template>		
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="ol/li">
		<xsl:call-template name="getLevelListItem">
			<xsl:with-param name="list-label">.</xsl:with-param>
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>		
	</xsl:template>
	
	<xsl:template name="getLevelListItem">
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
		
	</xsl:template>
	
	<xsl:template match="sec/text() | li/text() | ul/text() | ol/text() | inscope/text() | outscope/text()">
		<xsl:value-of select="normalize-space(.)"/>
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