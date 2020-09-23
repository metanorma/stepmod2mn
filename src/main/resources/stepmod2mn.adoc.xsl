<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mml="http://www.w3.org/1998/Math/MathML" 
		xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:xalan="http://xml.apache.org/xalan" 
		xmlns:java="http://xml.apache.org/xalan/java" 
		exclude-result-prefixes="mml tbx xlink xalan java" 
		version="1.0">

	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:strip-space elements="*"/>
			
	<xsl:param name="path"/>
	
	
	<xsl:param name="output_issues" select="'NO'"/>
	
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
		
		
		
	</xsl:template>
	
	
	<!-- =========== -->
	<!--  Foreword -->
	<xsl:template match="resource_clause" mode="foreword">		
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
		<xsl:choose>
			<xsl:when test="@pos">				
				<xsl:apply-templates select="$resource_xml" mode="foreword_resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml" mode="foreword_resource"/>
			 </xsl:otherwise>
		 </xsl:choose>
	</xsl:template>
	
	<!-- from res_doc/resource.xsl -->
	<xsl:template match="resource" mode="foreword_resource">
		<xsl:variable name="status" select="string(@status)"/>
		<xsl:variable name="part_no">
			<xsl:call-template name="get_resdoc_iso_number_without_status">
				<xsl:with-param name="resdoc" select="./@name"/>
			</xsl:call-template>
		</xsl:variable>
	
		<xsl:text>.Foreword</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>ISO (the International Organization for Standardization) is a worldwide federation of national standards bodies (ISO member bodies). The work of preparing International Standards is normally carried out through ISO technical committees. Each member body interested in a subject for which a technical committee has been established has the right to be represented on that committee. International organizations, governmental and non-governmental, in liaison with ISO, also take part in the work. ISO collaborates closely with the International Electrotechnical Commission (IEC) on all matters of electrotechnical standardization.</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>		
		<xsl:text>The procedures used to develop this document and those intended for its further maintenance are described in the ISO/IEC Directives, Part 1. In particular, the different approval criteria needed for the different types of ISO documents should be noted. This document was drafted in accordance with the editorial rules of the ISO/IEC Directives, Part 2 (see www.iso.org/directives[http://www.iso.org/directives]).</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:text>Attention is drawn to the possibility that some of the elements of this document may be the subject of patent rights. ISO shall not be held responsible for identifying any or all such patent rights. Details of any patent rights identified during the development of the document will be in the Introduction and/or on the ISO list of patent declarations received (see www.iso.org/patents[http://www.iso.org/patents]).</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>    
		<xsl:text>Any trade name used in this document is information given for the convenience of users and does not constitute an endorsement.</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>		
		<xsl:text>For an explanation on the voluntary nature of standards, the meaning of ISO specific terms and expressions related to conformity assessment, as well as information about ISO's adherence to the World Trade Organization (WTO) principles in the Technical Barriers to Trade (TBT) see www.iso.org/iso/foreword.html[http://www.iso.org/iso/foreword.html].</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>		
		<xsl:text>This document was prepared by Technical Committee ISO/TC 184, _Automation systems and integration_, Subcommittee SC 4, _Industrial data._</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		
		<xsl:choose>
			<xsl:when test="not(./foreword)">
				<xsl:if test="@version!='1'">
					<xsl:variable name="this_edition">
						<xsl:choose>
							<xsl:when test="@version='2'">second</xsl:when>
							<xsl:when test="@version='3'">third</xsl:when>
							<xsl:when test="@version='4'">fourth</xsl:when>
							<xsl:when test="@version='5'">fifth</xsl:when>
							<xsl:when test="@version='6'">sixth</xsl:when>
							<xsl:when test="@version='7'">seventh</xsl:when>
							<xsl:when test="@version='8'">eighth</xsl:when>
							<xsl:when test="@version='9'">ninth</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="prev_edition">
						<xsl:choose>
							<xsl:when test="@version='2'">first</xsl:when>
							<xsl:when test="@version='3'">second</xsl:when>
							<xsl:when test="@version='4'">third</xsl:when>
							<xsl:when test="@version='5'">fourth</xsl:when>
							<xsl:when test="@version='6'">fifth</xsl:when>
							<xsl:when test="@version='7'">sixth</xsl:when>
							<xsl:when test="@version='8'">seventh</xsl:when>
							<xsl:when test="@version='9'">eighth</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="@previous.revision.cancelled='NO'">
							<xsl:variable name="text">
								This <xsl:value-of select="$this_edition"/> edition <!--of
								<xsl:value-of select="$part_no"/>-->
								cancels and replaces the
								<xsl:value-of select="$prev_edition"/> edition  
								(<xsl:value-of select="concat($part_no,':',@previous.revision.year)"/>),
								which has been technically revised. 
								
								<xsl:choose>
									<!-- only changed a section of the document -->
									<xsl:when test="@revision.complete='NO'">
										<xsl:value-of select="@revision.scope"/>
										of the <xsl:value-of select="$prev_edition"/> 
										edition  
										<xsl:choose>
											<!-- will be Clauses/Figures/ etc so if contains 'es' 
					 then must be plural-->
											<xsl:when test="contains(@revision.scope,'es')">
												have
											</xsl:when>
											<xsl:otherwise>
												has
											</xsl:otherwise>
										</xsl:choose>
										been technically revised.
									</xsl:when>
									<xsl:otherwise>
										<!-- complete revision so no extra text -->
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="normalize-space($text)"/>
							<xsl:text>&#xa;&#xa;</xsl:text>
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:variable name="text">
								<!-- cancelled -->
								This <xsl:value-of select="$this_edition"/> edition 
								cancels and replaces the
								<xsl:value-of select="$prev_edition"/> edition
								(<xsl:value-of
									select="concat($part_no,':',@previous.revision.year)"/>), 
								
								<xsl:choose>
									<!-- only changed a section of the document -->
									<xsl:when test="@revision.complete='NO'">
										of which 
										<xsl:value-of select="@revision.scope"/>
										<xsl:choose>
											<!-- will be Clauses/Figures/ etc so if contains 'es' 
					 then must be plural-->
											<xsl:when test="contains(@revision.scope,'es')">
												have
											</xsl:when>
											<xsl:otherwise>
												has
											</xsl:otherwise>
										</xsl:choose>
										been technically revised.
									</xsl:when>
									<xsl:otherwise>
										which has been technically revised.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="normalize-space($text)"/>
							<xsl:text>&#xa;&#xa;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./foreword"/>
				<xsl:text>&#xa;&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="./changes">
			<xsl:variable name="annex_letter">
				<xsl:choose>
					<xsl:when test="./examples and ./tech_discussion">G</xsl:when>
					<xsl:when test="./examples or ./tech_discussion">F</xsl:when>
					<xsl:otherwise>E</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>			
			<xsl:variable name="text">A detailed description of the changes is provided in Annex &lt;&lt;g_change,annex=<xsl:value-of select="$annex_letter"/>&gt;&gt;.</xsl:variable>
			<xsl:value-of select="normalize-space($text)"/>
		</xsl:if>
		
		<xsl:text>A list of all parts in the ISO 10303 series can be found on the ISO website[http://standards.iso.org/iso/10303/tech/step_titles.htm].</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
		
		<xsl:text>Any feedback or questions on this document should be directed to the user’s national standards body. A complete listing of these bodies can be found at www.iso.org/members.html[https://www.iso.org/members.html].</xsl:text>
		<xsl:text>&#xa;&#xa;</xsl:text>
	
	</xsl:template>
	<!-- END Foreword -->
	<!-- =========== -->
	
	
	<!-- Introduction  -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="introduction">		
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
		<xsl:choose>
			<xsl:when test="@pos">				
				<xsl:apply-templates select="$resource_xml" mode="introduction_resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml" mode="introduction_resource"/>
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
							<xsl:text>&#xa;</xsl:text>
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
					<xsl:text>&#xa;</xsl:text>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

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

	<!-- common.xsl -->
  <xsl:template name="resource_directory">
    <xsl:param name="resource"/>
    <xsl:value-of select="concat('../../data/resources/',$resource)"/>
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
				<xsl:apply-templates select="$resource_xml" mode="scope_resource">
					 <xsl:with-param name="pos" select="string(@pos)"/>
				 </xsl:apply-templates>
			 </xsl:when>
			 <xsl:otherwise>
				 <xsl:apply-templates select="$resource_xml" mode="scope_resource"/>
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
	<!-- END Scope  -->
	<!-- =========== -->
	
	
	
	<!-- resource_clause.xsl -->
	<xsl:template match="resource_clause" mode="resource">
		<!-- Ex. <resource_clause directory="draughting_elements"/> -->
		value=<xsl:value-of select="@directory"/>
		<xsl:text>&#xa;</xsl:text>
		
		

		
		<!-- scope -->
		
		
		
		
	</xsl:template>
	
	
	<!-- common.xsl -->
	<xsl:template match="resource" mode="title">
		<xsl:variable
			name="lpart">
			<xsl:choose>
				<xsl:when test="string-length(@part)>0">
					<xsl:value-of select="@part"/>
				</xsl:when>
				<xsl:otherwise>
					XXXX
				</xsl:otherwise>
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

	<!-- Make first letter upper, and replace '_' to space -->
	<!-- Ex. draughting_elements  - Draughting elements -->
	<!-- TASKL replacee to java: -->
	<xsl:template name="res_display_name">
		<xsl:param name="res"/>
		<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="first_char" select="substring(translate($res,$LOWER,$UPPER),1,1)"/>
		<xsl:variable name="res_name" select="concat($first_char, translate(substring($res,2),'_',' '))"/>
		<xsl:value-of select="$res_name"/>
	</xsl:template>


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
						<xsl:value-of 
							select="concat($orgname,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
					</xsl:when>
					<xsl:when test="$status='TS' or $status='FDIS'">
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


	<xsl:template match="resource|module|application_protocol" mode="doctype">
		<xsl:choose>
			<xsl:when test="name(.)='application_protocol'">ap</xsl:when>
			<xsl:when test="name(.)='module'">am</xsl:when>
			<xsl:when test="name(.)='resource' and @part > 499 and ./schema[starts-with(@name,'aic_')] ">aic</xsl:when>
			<xsl:when test="name(.)='resource' and @part >  99">iar</xsl:when>
			<xsl:when test="name(.)='resource' and @part &lt;  99">igr</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
				<xsl:with-param name="message" select="concat('Error : unknown type,  part number:', @part)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="scope/text()">
		<xsl:value-of select="normalize-space(.)"/>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template match="inscope">
   <xsl:text>The following are within the scope of this part of ISO 10303: </xsl:text>
	 <xsl:text>&#xa;</xsl:text>
    <!--  output any issues -->
    <xsl:apply-templates select=".." mode="output_clause_issue">
      <xsl:with-param name="clause" select="'inscope'"/>
    </xsl:apply-templates>

    <!-- list items -->
		<!-- <ul> -->
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#xa;</xsl:text>
    <!-- </ul> -->
  </xsl:template>


	<xsl:template match="outscope">
		<xsl:text>The following are outside the scope of this part of ISO 10303: </xsl:text>
		<xsl:text>&#xa;</xsl:text>
    <!-- output any issues -->
    <xsl:apply-templates select=".." mode="output_clause_issue">
      <xsl:with-param name="clause" select="'outscope'"/>
    </xsl:apply-templates>

    <!-- list items -->
		<!-- <ul> -->
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#xa;</xsl:text>
    <!-- </ul> -->
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

	

	<xsl:template name="error_message">
		<xsl:param name="message"/>
		<xsl:param name="linebreakchar" select="'#'"/>
		<xsl:message>
			<xsl:value-of select="translate($message,$linebreakchar,'&#010;')"/>			
		</xsl:message>
	</xsl:template>

	<!-- projmg\resource_issues.xsl -->
	<xsl:template match="resource" mode="output_clause_issue">
		<xsl:param name="clause"/>
		<xsl:if test="$output_issues='YES'">
			<xsl:variable name="resdoc_dir">
				<xsl:call-template name="resdoc_directory">
					<xsl:with-param name="resdoc" select="@name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="dvlp_fldr" select="@development.folder"/>
			<xsl:if test="string-length($dvlp_fldr)>0">
				<xsl:variable name="issue_file" 
					select="concat($resdoc_dir,'/dvlp/issues.xml')"/>
				<xsl:apply-templates
					select="document($issue_file)/issues/issue[@type=$clause]" 
					mode="inline_issue">
					<xsl:sort select="@status" order="descending"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	
	<xsl:template name="resdoc_directory">
		<xsl:param name="resdoc"/>
		<xsl:value-of select="concat($path, '../../../data/resource_docs/',$resdoc)"/>
	</xsl:template>

	<!-- from common.xsl -->
	<xsl:template name="get_resdoc_iso_number_without_status">
		<xsl:param name="resdoc"/>
		<xsl:variable name="resdoc_dir">
			<xsl:call-template name="resdoc_directory">
				<xsl:with-param name="resdoc" select="$resdoc"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="part">
			<xsl:value-of select="document(concat($resdoc_dir,'/resource.xml'))/resource/@part"/>
		</xsl:variable>

			<xsl:variable name="orgname" select="'ISO'"/>

			<xsl:value-of select="concat($orgname,' 10303-',$part)"/>
	</xsl:template>



</xsl:stylesheet>