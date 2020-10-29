<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.33 2008/05/21 20:50:25 abf Exp $
	Author:  Rob Bodington, Eurostep Limited
	Owner:   Developed by Eurostep and supplied to NIST under contract.
	Purpose:
		 Templates that are common to most other stylesheets
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								version="1.0">


<!--  <xsl:import href="../common.xsl"/> -->
	<xsl:output method="html"/>



<!--
		 Output the resource doc title - used to create the HTML TITLE
		 If the global parameter: output_rcs in parameter.xsl
		 is set, then RCS version control information is displayed
-->
	

<xsl:template match="resource" mode="title">
	<xsl:variable name="lpart">
		<xsl:choose>
			<xsl:when test="string-length(@part)>0">
				<xsl:value-of select="@part"/>
			</xsl:when>
			<xsl:otherwise>XXXX</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="stdnumber">
		<xsl:call-template name="get_resdoc_stdnumber">
			<xsl:with-param name="resdoc" select="."/>
		</xsl:call-template>
	</xsl:variable>

<!-- should not be in title according to sc4n1548
	<xsl:variable name="resdoc_name">
		<xsl:call-template name="res_display_name">
			<xsl:with-param name="res" select="@name"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:value-of select="concat($stdnumber,' ',$resdoc_name)"/>
-->
	<xsl:value-of select="$stdnumber"/>

</xsl:template>



	<xsl:template match="resource" mode="display_name">
		<xsl:variable name="this-type">
			<xsl:apply-templates select="." mode="type"/>
		</xsl:variable>
		<xsl:value-of select="concat($this-type,': ')" />
		<xsl:call-template name="module_display_name">
			<xsl:with-param name="module" select="@name"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="resource" mode="display_name_french">
		<xsl:variable name="this-type">
			<xsl:apply-templates select="." mode="display_french_doctype"/>
		</xsl:variable>
		<xsl:value-of select="concat($this-type,': ')" />
		<xsl:call-template name="module_display_name">
			<xsl:with-param name="module" select="@name.french"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="resource" mode="page_count">
		<xsl:variable name="expg_count" select="count(.//express-g/imgfile)" />
		<xsl:variable name="schema_count" select="count(.//schema)" />
		<xsl:variable name="tech_disc_count" select="count(.//tech_discussion)" />
		<xsl:variable name="add_scope" select="count(.//add_scope)" />
		<xsl:value-of select="$expg_count + $schema_count + $schema_count  + 16" />
	</xsl:template>




	<!-- a reference to an EXPRESS construct in a module ARM or MIM or in the
			 Integrated Resource. The format of the linkend attribute that
			 defines the reference is:
		 <module or resources or resource_doc dirname>:mim|arm|arm_express|mim_express|ir|ir_express:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>

		 where:
			<module> - the name of the module
			 arm - links to the arm documentation
			 arm_express - links to the arm express
			 mim - links to the mim documentation
			 mim_express - links to the mim express
			 ir_express - links to the ir express
			 ir  - links to the ir documentation

		 e.g. work_order:arm:work_order_arm.Activity.name

		 To address an EXPRESS construct in an Integrated Resource schema:
		 <ir>:ir_express:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>
-->
	<xsl:template match="express_ref">

		<xsl:call-template name="check_express_ref">
			<xsl:with-param name="linkend" select="@linkend"/>
		</xsl:call-template>

		<xsl:variable name="href">
			<xsl:call-template name="get_href_from_express_ref">
				<xsl:with-param name="linkend" select="@linkend"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="item">
			<xsl:call-template name="get_last_section">
				<xsl:with-param name="path" select="@linkend"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$href=''">
				<xsl:call-template name="error_message">
					<xsl:with-param
						name="message"
						select="concat('ERROR c2: express_ref linkend #',
										@linkend,
										'# is incorrectly specified.')"/>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test="string-length(.)>0">
						<!-- <b><xsl:apply-templates/></b> -->
						<xsl:text> *</xsl:text><xsl:apply-templates/><xsl:text>* </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!-- <b><xsl:value-of select="$item"/></b> -->
						<xsl:text> *</xsl:text><xsl:value-of select="$item"/><xsl:text>* </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:text> *</xsl:text> -->
				<xsl:variable name="link_text">
					<xsl:choose>
						<xsl:when test="string-length(.)>0">
							<!-- <a href="{$href}"><b><xsl:apply-templates/></b></a> -->
							<xsl:apply-templates/>
						</xsl:when>
						<xsl:otherwise>
							<!-- <a href="{$href}"><b><xsl:value-of select="$item"/></b></a> -->            
							<xsl:value-of select="$item"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="contains($href, concat('/', $current_module, '/'))"><!-- if link inside current module -->
						<xsl:text>&lt;&lt;</xsl:text><xsl:value-of select="substring-after($href,'#')"/><xsl:text>&gt;&gt;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
					
						<xsl:call-template name="insertHyperlink">
							<xsl:with-param name="a">
								<a href="{$href}"><xsl:value-of select="$link_text"/></a>							
							</xsl:with-param>
						</xsl:call-template>						
					
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	

	<!-- A reference to a section of the module.
			 The format of the linkend attribute that defines the reference is:
			 <module>:<section>:<construct>:<id>

		 where:
			<module> is the name of the module
			<section> is either:
				 introduction
				 1_scope
				 1_inscope
				 1_outscope
				 2_normrefs
				 3_definition
				 3_abbreviations
				 4_uof
				 4_interfaces
				 4_constants
				 4_types
				 4_entities
				 4_subtype_constraints
				 4_rules
				 4_functions
				 4_procedures
				 5_mapping
				 5_mim_express
				 5_interfaces
				 5_constants
				 5_types
				 5_entities
				 5_rules
				 5_functions
				 5_procedures
				 f_usage_guide
			<construct> is optional and is either:
				 figure
				 note
				 example
				 table
			<id> if a construct is given, then id is the identifier for the
					 construct.
			-->
	<xsl:template match="resdoc_ref">
		<!-- remove all whitespace -->
		<xsl:variable
			name="nlinkend"
			select="translate(@linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

		<xsl:variable name="resdoc">
			<xsl:choose>
				<xsl:when test="contains($nlinkend,':')">
					<xsl:value-of select="substring-before($nlinkend,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nlinkend"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable
			name="nlinkend1"
			select="substring-after($nlinkend,':')"/>

		<xsl:variable name="section_tmp">
			<xsl:choose>
				<xsl:when test="contains($nlinkend1,':')">
					<xsl:value-of select="substring-before($nlinkend1,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nlinkend1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- now check that section is a valid reference -->
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="$section_tmp='introduction'
												or $section_tmp='1_scope'
												or $section_tmp='1_inscope'
												or $section_tmp='1_outscope'
												or $section_tmp='2_normrefs'
												or $section_tmp='3_definition'
												or $section_tmp='3_abbreviations'
												or $section_tmp='4_uof'
												or $section_tmp='4_interfaces'
												or $section_tmp='4_constants'
												or $section_tmp='4_types'
												or $section_tmp='4_entities'
												or $section_tmp='4_subtype_constraints'
												or $section_tmp='4_rules'
			or $section_tmp='4_subtype_constraints'
												or $section_tmp='4_functions'
												or $section_tmp='4_procedures'
												or $section_tmp='5_mapping'
												or $section_tmp='5_mim_express'
												or $section_tmp='5_interfaces'
												or $section_tmp='5_constants'
												or $section_tmp='5_types'
												or $section_tmp='5_entities'
												or $section_tmp='5_subtype_constraints'
												or $section_tmp='5_rules'
												or $section_tmp='5_functions'
												or $section_tmp='5_procedures'
												or $section_tmp='f_usage_guide'">
					<xsl:value-of select="$section_tmp"/>
				</xsl:when>
				<xsl:otherwise>
					<!--
							 error - will be picked up after the  href variable is set.
							 -->
					<xsl:value-of select="'error'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable
			name="nlinkend2"
			select="substring-after($nlinkend1,':')"/>

		<xsl:variable name="construct_tmp">
			<xsl:choose>
				<xsl:when test="contains($nlinkend2,':')">
					<xsl:value-of select="substring-before($nlinkend2,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nlinkend2"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable
			name="nlinkend3"
			select="substring-after($nlinkend2,':')"/>

		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="contains($nlinkend3,':')">
					<xsl:value-of select="substring-before($nlinkend3,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nlinkend3"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="construct">
			<xsl:choose>
				<!-- test that a valid value is given for construct -->
				<xsl:when test="$construct_tmp='example'
												or $construct_tmp='note'
												or $construct_tmp='figure'">
					<xsl:choose>
						<!-- test that an id has been given -->
						<xsl:when test="$id!=''">
							<xsl:value-of select="concat('#',$construct_tmp,'_',$id)"/>
						</xsl:when>
						<xsl:otherwise>
							<!--
									 error - will be picked up after the  href variable is set.
									 -->
							<xsl:value-of select="'error'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$construct_tmp=''"/>

				<xsl:otherwise>
					<!--
							 error - will be picked up after the  href variable is set.
							 -->
					<xsl:value-of select="'error'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="href">
			<xsl:choose>
				<xsl:when test="$resdoc=''">
					<!--
							 error do nothing as the error will be picked up after the
							 href variable is set.
							 -->
				</xsl:when>
				<xsl:when test="$section='error'">
					<!--
							 error do nothing as the error will be picked up after the
							 href variable is set.
							 -->
				</xsl:when>
				<xsl:when test="$construct='error'">
					<!--
							 error do nothing as the error will be picked up after the
							 href variable is set.
							 -->
				</xsl:when>
				<xsl:when test="$section=''">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,'/sys/introduction',
										$FILE_EXT)"/>
				</xsl:when>
				<xsl:when test="$section='introduction'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,'/sys/introduction',
										$FILE_EXT,$construct)"/>
				</xsl:when>
				<xsl:when test="$section='1_scope'">
					<xsl:choose>
						<xsl:when test="$construct">
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/1_scope',$FILE_EXT,$construct)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/1_scope',$FILE_EXT,'#scope')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$section='1_inscope'">
					<xsl:choose>
						<xsl:when test="$construct=''">
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/1_scope',$FILE_EXT,'#inscope')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/1_scope',$FILE_EXT,$construct)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:when test="$section='1_outscope'">
					<xsl:choose>
						<xsl:when test="$construct=''">
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/1_scope',$FILE_EXT,'#outscope')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/1_scope',$FILE_EXT,$construct)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>


				<xsl:when test="$section='2_normrefs'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/2_refs',$FILE_EXT)"/>
				</xsl:when>
				<xsl:when test="$section='3_definition'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/3_defs',$FILE_EXT)"/>
				</xsl:when>
				<xsl:when test="$section='3_abbreviations'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/3_defs',$FILE_EXT)"/>
				</xsl:when>
				<xsl:when test="$section='4_uof'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#uof')"/>
				</xsl:when>
				<xsl:when test="$section='4_interfaces'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#interfaces')"/>
				</xsl:when>
				<xsl:when test="$section='4_constants'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#constants')"/>
				</xsl:when>
				<xsl:when test="$section='4_types'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#types')"/>
				</xsl:when>
				<xsl:when test="$section='4_entities'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#entities')"/>
				</xsl:when>
				
				<xsl:when test="$section='4_subtype_constraints'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#subtype_constraints')"/>
				</xsl:when>
 
				<xsl:when test="$section='4_rules'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#rules')"/>
				</xsl:when>
				<xsl:when test="$section='4_functions'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#functions')"/>
				</xsl:when>
				<xsl:when test="$section='4_procedures'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/4_info_reqs',$FILE_EXT,'#procedures')"/>
				</xsl:when>
				<xsl:when test="$section='5_mapping'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#mapping')"/>
				</xsl:when>
				<xsl:when test="$section='5_mim_express'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#mim_express')"/>
				</xsl:when>
				<xsl:when test="$section='5_interfaces'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#interfaces')"/>
				</xsl:when>
				<xsl:when test="$section='5_constants'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#constants')"/>
				</xsl:when>
				<xsl:when test="$section='5_types'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#types')"/>
				</xsl:when>
				<xsl:when test="$section='5_entities'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#entities')"/>
				</xsl:when>

				<xsl:when test="$section='5_subtype_constraints'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#subtype_constraints')"/>
				</xsl:when>

				<xsl:when test="$section='5_rules'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#rules')"/>
				</xsl:when>
				<xsl:when test="$section='5_functions'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#functions')"/>
				</xsl:when>
				<xsl:when test="$section='5_procedures'">
					<xsl:value-of
						select="concat('../../../resource_docs/',$resdoc,
										'/sys/5_mim',$FILE_EXT,'#procedures')"/>
				</xsl:when>

				<xsl:when test="$section='f_usage_guide'">
					<xsl:choose>
						<xsl:when test="$construct">
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
										'/sys/f_guide',$FILE_EXT,$construct)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat('../../../resource_docs/',$resdoc,
												'/sys/f_guide',$FILE_EXT,'#annexf')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!--
							 error - will be picked up after the  href variable is set.
							 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

 <!-- debug
		[sect:<xsl:value-of select="$section"/>]
		[resdoc:<xsl:value-of select="$resdoc"/>]
		[href:<xsl:value-of select="$href"/>]
		[construct:<xsl:value-of select="$construct"/>]
	-->   
		<xsl:choose>
			<xsl:when test="$href=''">
				<xsl:call-template name="error_message">
					<xsl:with-param
						name="message"
						select="concat('ERROR c3: module_ref linkend #',
										$nlinkend,
										'# is incorrectly specified.')"/>
				</xsl:call-template>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <a href="{$href}"><xsl:apply-templates/></a> -->
				
				<xsl:call-template name="insertHyperlink">
					<xsl:with-param name="a">
						<a href="{$href}"><xsl:apply-templates/></a>							
					</xsl:with-param>
				</xsl:call-template>						
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- return the standard number of the module -->
<xsl:template name="get_resdoc_stdnumber">
	<xsl:param name="resdoc"/>
	<xsl:variable name="part">
		<xsl:choose>
			<xsl:when test="string-length($resdoc/@part)>0">
				<xsl:value-of select="$resdoc/@part"/>
			</xsl:when>
				<xsl:otherwise>
					&lt;part&gt;
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	 <xsl:variable name="status">
		<xsl:choose>
			<xsl:when test="string-length($resdoc/@status)>0">
				<xsl:value-of select="string($resdoc/@status)"/>
			</xsl:when>
				<xsl:otherwise>
					&lt;status&gt;
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="string-length($resdoc/@language)">
					<xsl:value-of select="$resdoc/@language"/>
				</xsl:when>
				<xsl:otherwise>
					E
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- 
				 Note, if the standard has a status of CD or CD-TS it has not been
				 published - so overide what ever is the @publication.year 
				 -->
		<xsl:variable name="pub_year">
			<xsl:choose>
				<xsl:when test="$status='CD' or $status='CD-TS'">-</xsl:when>
				<xsl:when test="string-length($resdoc/@publication.year)">
					<xsl:value-of select="$resdoc/@publication.year"/>
				</xsl:when>
				<xsl:otherwise>
					&lt;publication.year&gt;
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="orgname" select="'ISO'"/>

		<xsl:variable name="stdnumber">
			<xsl:choose>
				<xsl:when test="$status='IS'">
					<xsl:value-of select="concat($orgname,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
				</xsl:when>
				<xsl:when test="$status='TS' or $status='FDIS'">
					<xsl:value-of select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($orgname,'/',$status,' 10303-',$part)"/>          
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="$stdnumber"/>

</xsl:template>



	<!-- the number of the document for display as a page heaer.
			 Used on the cover page and every page header. -->
	<xsl:template name="get_resdoc_pageheader">
		<xsl:param name="resdoc"/>
		<xsl:variable name="part">
			<xsl:choose>
				<xsl:when test="string-length($resdoc/@part)>0">
					<xsl:value-of select="$resdoc/@part"/>
				</xsl:when>
					<xsl:otherwise>
						&lt;part&gt;
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

		 <xsl:variable name="status">
			<xsl:choose>
				<xsl:when test="string-length($resdoc/@status)>0">
					<xsl:value-of select="string($resdoc/@status)"/>
				</xsl:when>
					<xsl:otherwise>
						&lt;status&gt;
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="language">
				<xsl:choose>
					<xsl:when test="string-length($resdoc/@language)">
						<xsl:value-of select="$resdoc/@language"/>
					</xsl:when>
					<xsl:otherwise>
						E
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- 
					 Note, if the standard has a status of CD or CD-TS it has not been
					 published - so overide what ever is the @publication.year 
					 -->
			<xsl:variable name="pub_year">
				<xsl:choose>
					<xsl:when test="$status='CD' or $status='CD-TS'">-</xsl:when>
					<xsl:when test="string-length($resdoc/@publication.year)">
						<xsl:value-of select="$resdoc/@publication.year"/>
					</xsl:when>
					<xsl:otherwise>
						&lt;publication.year&gt;
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="orgname" select="'ISO'"/>

			<xsl:variable name="stdnumber">
				<xsl:choose>
					<xsl:when test="$status='IS'">
						<xsl:value-of 
							select="concat($orgname,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
					</xsl:when>
					<xsl:when test="$status='TS'">
						<xsl:value-of 
							select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
					</xsl:when>
					<xsl:when test="$status='FDIS'">
						<xsl:value-of 
							select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of 
							select="concat($orgname,'/',$status,' 10303-',$part)"/>          
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:value-of select="$stdnumber"/>

	</xsl:template>
	

<xsl:template name="get_resdoc_wg_group">
	<xsl:choose>
		<xsl:when test="string-length(/resdoc/@sc4.working_group)>0">
			<xsl:value-of select="normalize-space(/resource/@sc4.working_group)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="string('12')"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="test_resdoc_wg_group">
	<xsl:param name="resdoc"/>
	<xsl:variable name="wg_group">
		<xsl:call-template name="get_resdoc_wg_group"/>
	</xsl:variable>
	
	<xsl:if test="not($wg_group = '3')">
		<xsl:call-template name="error_message">
			<xsl:with-param name="message">
				<xsl:value-of select="concat('Error in
															resource.xml/resource/@sc4.working_group - ',
															$wg_group,' Should be 3')"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


<xsl:template name="get_resdoc_iso_number">
	<xsl:param name="resdoc"/>
	<xsl:variable name="resdoc_dir">
		<xsl:call-template name="resdoc_directory">
			<xsl:with-param name="resdoc" select="$resdoc"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="part">
		<xsl:value-of
			select="document(concat($resdoc_dir,'/resource.xml'))/resource/@part"/>
	</xsl:variable>
	<xsl:variable name="status">
		<xsl:value-of
			select="document(concat($resdoc_dir,'/resource.xml'))/resource/@status"/>
	</xsl:variable>

		<xsl:variable name="orgname" select="'ISO'"/>

		<xsl:variable name="stdnumber">
			<xsl:choose>
				<xsl:when test="$status='IS'">
					<xsl:value-of 
						select="concat($orgname,' 10303-',$part)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of 
						select="concat($orgname,'/',$status,' 10303-',$part)"/>          
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="$stdnumber"/>
</xsl:template>

<xsl:template name="get_resdoc_iso_number_without_status">
	<xsl:param name="resdoc"/>
	<xsl:variable name="resdoc_dir">
		<xsl:call-template name="resdoc_directory">
			<xsl:with-param name="resdoc" select="$resdoc"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="part">
		<xsl:value-of
			select="document(concat($resdoc_dir,'/resource.xml'))/resource/@part"/>
	</xsl:variable>

		<xsl:variable name="orgname" select="'ISO'"/>

		<xsl:value-of select="concat($orgname,' 10303-',$part)"/>
</xsl:template>



</xsl:stylesheet>


