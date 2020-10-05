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
			<xsl:text>&#xa;&#xa;</xsl:text>
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
	
	
	
	<!-- Normative References -->
	<!-- =========== -->
	<xsl:template match="resource_clause" mode="norm_refs">	
		<xsl:variable name="resource_xml" select="document(concat($path, '../',@directory,'/resource.xml'))"/>
	    
		<xsl:apply-templates select="$resource_xml" mode="norm_refs_resource"/>
		
	</xsl:template>
	
	
	<xsl:template match="resource" mode="norm_refs_resource">
		<xsl:call-template name="output_normrefs">
			<xsl:with-param name="resource_number" select="./@part"/>
			<xsl:with-param name="current_resource" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- from res_doc\resource.xsl -->
  <xsl:template name="output_normrefs">
    <xsl:param name="resource_number"/>
    <xsl:param name="current_resource"/>

		<xsl:text>[bibliography]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
    <xsl:text>== Normative references</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
    
    <xsl:text>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</xsl:text>
    <xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
    <!-- output any issues -->
    <xsl:apply-templates select="." mode="output_clause_issue">
      <xsl:with-param name="clause" select="'normrefs'"/>
    </xsl:apply-templates>  


    <!-- output the normative references explicitly defined in the resource -->
    <xsl:apply-templates select="/resources/normrefs/normref">
      <xsl:with-param name="current_resource" select="$current_resource"/>
    </xsl:apply-templates>


    <!-- output the default normative references  -->

    <xsl:call-template name="output_default_normrefs">
      <xsl:with-param name="resource_number" select="$resource_number"/>
      <xsl:with-param name="current_resource" select="$current_resource"/>
    </xsl:call-template>

  </xsl:template>

	<!-- Output the normative reference -->
	<xsl:template match="normref">
		<xsl:variable name="stdnumber">
			<xsl:value-of select="concat(stdref/orgname,' ',stdref/stdnumber)"/><!-- &#160; -->
		</xsl:variable>
		
		<xsl:variable name="text">
			<xsl:text>[[[</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$stdnumber"/>
			<xsl:text>]]]</xsl:text>
			
			<xsl:if test="stdref[@published='n']">
				<xsl:text> footnote:[To be published.]</xsl:text>				
			</xsl:if>
			<xsl:text>, </xsl:text>
			
			<xsl:variable name="text_i">			
				<xsl:value-of select="stdref/stdtitle"/>
				<xsl:variable name="subtitle" select="normalize-space(stdref/subtitle)"/>				
				<xsl:choose>
					<xsl:when test="substring($subtitle, string-length($subtitle)) = '.'">
						<xsl:value-of select="substring($subtitle, 1, (string-length($subtitle)-1))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$subtitle"/>
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:variable>
			
			<xsl:text>_</xsl:text><xsl:value-of select="$text_i"/><xsl:text>_</xsl:text>
		</xsl:variable>
		<xsl:value-of select="$text"/>
		
	</xsl:template>

	
	<!-- output the default normative reference -->
	<xsl:template name="output_default_normrefs">
		<xsl:param name="resource_number"/>
		<xsl:param name="current_resource"/>

		<xsl:variable name="normrefs">
			<xsl:call-template name="normrefs_list">
				<xsl:with-param name="current_resource" select="$current_resource"/>
			</xsl:call-template>
		</xsl:variable>
		<!--
	<xsl:message>
	normrefs:<xsl:value-of select="$normrefs"/>:normrefs
	</xsl:message> 
		-->

		<xsl:variable name="pruned_normrefs">
			<xsl:call-template name="prune_normrefs_list">
				<xsl:with-param name="normrefs_list" select="$normrefs"/>
			</xsl:call-template>  
		</xsl:variable>

		<!--
	<xsl:message>
	pruned_normrefs:<xsl:value-of select="$pruned_normrefs"/>:pruned_normrefs
	</xsl:message>
		-->

		<xsl:variable name="normrefs_to_be_sorted">
			<xsl:call-template name="output_normrefs_rec">
				<xsl:with-param name="normrefs" select="$pruned_normrefs"/>
				<xsl:with-param name="resource_number" select="$resource_number"/>
			</xsl:call-template>  
		</xsl:variable>
		
	<!-- <xsl:message>
	normrefs_to_be_sorted:<xsl:copy-of select="$normrefs_to_be_sorted"/>:normrefs_to_be_sorted
	</xsl:message> -->
		
		<xsl:for-each select="xalan:nodeset($normrefs_to_be_sorted)/normref">
						<!-- sorting basis is special normalized string, consisting of organization, series and part number all of equal lengths per each element -->
			<xsl:sort select='part'/>			
			<xsl:for-each select="string">
				<xsl:text>* </xsl:text><xsl:value-of select="normalize-space(.)"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>

		<!-- output a footnote to say that the normative reference has not been published -->

		<xsl:call-template name="output_unpublished_normrefs">
			<xsl:with-param name="normrefs" select="$normrefs"/>
		</xsl:call-template>

		<!-- output a footnote to say that the normative reference has not been published -->
		<xsl:call-template name="output_derogated_normrefs">
			<xsl:with-param name="normrefs" select="$normrefs"/>
			<xsl:with-param name="current_resource" select="$current_resource"/>
		</xsl:call-template>
		
	</xsl:template>



  <!-- build a list of normrefs that are used by the resource.
       The list comprises:
       All normrefs explicitly included in the resource by normref.inc
       All default normrefs that define terms for which abbreviations are provided and listed in ../data/basic/abbreviations_default.xml
       All resources referenced by a USE FROM in any schema
  -->
	<xsl:template name="normrefs_list">
		<xsl:param name="current_resource"/>

		<xsl:variable name="doctype">
			<xsl:apply-templates select="$current_resource" mode="doctype"/>
		</xsl:variable>

		<!-- get all default normrefs listed in ../../data/basic/normrefs_resdoc_default.xml -->
		<xsl:variable name="normref_list1">
			<xsl:choose>
				<xsl:when test="not($doctype='aic')">
					<xsl:call-template name="get_normref">
						<xsl:with-param name="normref_nodes" select="document(concat($path, '../../../data/basic/normrefs_resdoc_default.xml'))/normrefs/normref.inc"/>
						<xsl:with-param name="normref_list" select="''"/>
					</xsl:call-template> 
				</xsl:when>
				<xsl:when test="$doctype='aic'">
					<xsl:call-template name="get_normref">
						<xsl:with-param name="normref_nodes" select="document(concat($path, '../../../data/basic/normrefs_aic_default.xml'))/normrefs/normref.inc"/>
						<xsl:with-param name="normref_list" select="''"/>
					</xsl:call-template> 
				</xsl:when>
			</xsl:choose>   
		</xsl:variable>

		<!--
	<xsl:message>
	l1:<xsl:value-of select="$normref_list1"/>:l1
	</xsl:message>
		-->


		<!-- get all normrefs explicitly included in the resource by normref.inc -->
		<xsl:variable name="normref_list2">
			<xsl:call-template name="get_normref">
				<xsl:with-param name="normref_nodes" select="/resource/normrefs/normref.inc"/>
				<xsl:with-param name="normref_list" select="$normref_list1"/>
			</xsl:call-template>    
		</xsl:variable>
		<!--
	<xsl:message>
	l2:<xsl:value-of select="$normref_list2"/>:l2
	</xsl:message>
		-->

		<!-- get all normrefs that define terms for which abbreviations are
	 provided.
	 Get the abbreviation.inc from abbreviations_default.xml, 
	 get the referenced abbreviation from abbreviations.xml
	 then get the normref in which the term is defined
		-->
		<xsl:variable name="normref_list3">
			<xsl:choose>
				<xsl:when test="not($doctype='aic')">
					<xsl:call-template name="get_normrefs_from_abbr">
						<xsl:with-param name="abbrvinc_nodes" select="document(concat($path, '../../../data/basic/abbreviations_resdoc_default.xml'))/abbreviations/abbreviation.inc"/>
						<xsl:with-param name="normref_list" select="$normref_list2"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$doctype='aic'">
					<xsl:call-template name="get_normrefs_from_abbr">
						<xsl:with-param name="abbrvinc_nodes" select="document(concat($path, '../../../data/basic/abbreviations_aic_default.xml'))/abbreviations/abbreviation.inc"/>
						<xsl:with-param name="normref_list" select="$normref_list2"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!--
	<xsl:message>
	l3:<xsl:value-of select="$normref_list3"/>:l3
	</xsl:message>
		-->

		<!-- get all resources referenced by a USE FROM 
	 - need to get this working -->
		<xsl:variable name="resource_dir">
			<xsl:call-template name="resource_directory">
				<xsl:with-param name="resource" select="/resource/@name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="schema_xml" select="concat($resource_dir,'/resource.xml')"/>
		<!-- for now hard code as normref_list3
	 <xsl:variable name="normref_list4">
	 
	 <xsl:call-template name="get_normrefs_from_schema">
	 <xsl:with-param 
	 name="interface_nodes" 
	 select="document($schema_xml)/express/schema/interface"/>
	 <xsl:with-param 
	 name="normref_list" 
	 select="$normref_list3"/>
	 </xsl:call-template>
	 </xsl:variable>
		-->

		<xsl:variable name="normref_list4" select="$normref_list3"/>
		<!--
	<xsl:message>
	l4:<xsl:value-of select="$normref_list4"/>:l4
	</xsl:message>
		-->
		<xsl:value-of select="$normref_list4"/>
	</xsl:template>


	<!-- add a normref id to the set of normref ids. -->
	<xsl:template name="add_normref">
		<xsl:param name="normref"/>
		<xsl:param name="normref_list"/>
		<!-- end the list with a , -->
		<xsl:variable name="normref_list_term" select="concat($normref_list,',')"/>
		<xsl:variable name="normref_list1">
			<xsl:choose>
				<xsl:when test="contains($normref_list_term, concat(',',$normref,','))">
					<xsl:value-of select="$normref_list"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($normref_list,',',$normref,',')"/>      
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$normref_list1"/>
	</xsl:template>

	
	<xsl:template name="prune_normrefs_list">
		<xsl:param name="normrefs_list"/>
		<xsl:param name="pruned_normrefs_list" select="''"/>
		<xsl:param name="pruned_normrefs_ids" select="''"/>
		<xsl:choose>
			<xsl:when test="$normrefs_list">
				<xsl:variable name="first" select="substring-before(substring-after($normrefs_list,','),',')"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs_list,','),',')"/>

				<xsl:variable name="add_to_pruned_normrefs_ids">
					<xsl:choose>
						<xsl:when test="contains($first,'normref:')">
							<!--  The default or explicit deal normrefs have
						 already been pruned so just add -->
							<xsl:variable name="id" select="substring-after($first,'normref:')"/>

							<xsl:variable name="normref">
							<xsl:apply-templates select="document(concat($path, '../../../data/basic/normrefs.xml'))/normref.list/normref[@id=$id]" mode="prune_normrefs_list"/>
							</xsl:variable>
							<!-- return the normref to be added to the list -->
							<xsl:value-of select="$normref"/>
						</xsl:when>

						<xsl:when test="contains($first,'resource:')">
							<xsl:variable name="resource" select="substring-after($first,'resource:')"/>							
							<xsl:variable name="resource_dir">
							<xsl:call-template name="resource_directory">
								<xsl:with-param name="resource" select="$resource"/>
							</xsl:call-template>
							</xsl:variable>							
							<xsl:variable name="resource_ok">
								<xsl:call-template name="check_resource_exists">
									<xsl:with-param name="schema" select="$resource"/>
								</xsl:call-template>
							</xsl:variable>
							
							<xsl:variable name="resource_xml" select="concat($resource_dir,'/resource.xml')"/>

							
							<!-- output the normative reference derived from the resource -->
							<xsl:variable name="normref">
								<xsl:if test="$resource_ok='true'">
									<xsl:apply-templates select="document($resource_xml)/resource" mode="prune_normrefs_list"/>
								</xsl:if>
							</xsl:variable>
							
							<!-- if the normref for the resource has been already been added,
						 ignore -->
							<xsl:if test="not(contains($pruned_normrefs_ids,$normref))">
								<!-- return the normref to be added to the list -->
								<xsl:value-of select="$normref"/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="contains($first,'resource:')">
							<!-- 
						 NO PRUNING TAKING PLACE - JUST MAKING SURE THAT THE
						 RESOURCE STAY IN THE LIST -->
							<xsl:variable name="resource" select="substring-after($first,'resource:')"/>
							<xsl:value-of select="$resource"/>
						</xsl:when>
						<xsl:otherwise/>						
					</xsl:choose>
				</xsl:variable> <!-- add_to_pruned_normrefs_ids -->
	
				<xsl:variable name="new_pruned_normrefs_ids">
					<xsl:choose>
						<xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
							<xsl:value-of select="concat($pruned_normrefs_ids,',',$add_to_pruned_normrefs_ids,',')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pruned_normrefs_ids"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="new_pruned_normrefs_list">
					<xsl:choose>
						<xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
							<xsl:value-of select="concat($pruned_normrefs_list,',',$first,',')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pruned_normrefs_list"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="prune_normrefs_list">
					<xsl:with-param name="normrefs_list" select="$rest"/>
					<xsl:with-param name="pruned_normrefs_list" select="$new_pruned_normrefs_list"/>
					<xsl:with-param name="pruned_normrefs_ids" select="$new_pruned_normrefs_ids"/>
				</xsl:call-template>  

			</xsl:when>
			<xsl:otherwise>
				<!-- end of recursion -->
				<xsl:value-of select="$pruned_normrefs_list"/>
			</xsl:otherwise>
		</xsl:choose>   
	</xsl:template>

	
	<xsl:template name="output_resource_normref">
		<xsl:param name="resource_schema"/>
		<xsl:variable name="ir_ok">
			<xsl:call-template name="check_resource_exists">
				<xsl:with-param name="schema" select="$resource_schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ir_ref">
			<xsl:if test="$ir_ok='true'">
				<xsl:value-of select="document(concat($path, '../../../data/resources/', $resource_schema,'/',$resource_schema,'.xml'))/express/@reference"/>
			</xsl:if>
		</xsl:variable>

		<p>
			<xsl:call-template name="error_message">
				<xsl:with-param name="message">
					<xsl:value-of 
							select="concat('Warning 8: MIM uses schema ', 
								$resource_schema, 
								'Make sure you include Integrated resource (',
								$ir_ref,
								') that defines it as a normative reference. ',
								'Use: normref.inc')"/>
				</xsl:with-param>
				<xsl:with-param name="inline" select="'no'"/>
			</xsl:call-template>
		</p>
	</xsl:template>

	

	<xsl:template name="output_normrefs_rec">
		<xsl:param name="resource_number"/>
		<xsl:param name="normrefs"/>

		<xsl:choose>
			<xsl:when test="$normrefs">
				<xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>      

				<xsl:choose>
					<xsl:when test="contains($first,'normref:')">
						<xsl:variable name="normref" select="substring-after($first,'normref:')"/>

						<xsl:variable name="normref_node" select="document(concat($path, '../../../data/basic/normrefs.xml'))/normref.list/normref[@id=$normref]"/>
						
						<xsl:choose>
							<xsl:when test="$normref_node">   
					<!-- don't output the normref if referring to current resource
					-->
					<!-- normref stdnumber are 10303-1107 whereas resource numbers are
							 1107, so remove the 10303- -->
								<xsl:variable name="part_no" select="substring-after($normref_node/stdref/stdnumber,'-')"/>
									<xsl:element name="normref">
										 <xsl:element name="string">											
											<xsl:if test="$resource_number!=$part_no">
												<!-- OOUTPUT from normative references -->
													<xsl:apply-templates select="document(concat($path, '../../../data/basic/normrefs.xml'))/normref.list/normref[@id=$normref]"/>
											</xsl:if>
										</xsl:element>
										<xsl:variable name="part">
											<xsl:value-of select="document(concat($path, '../../../data/basic/normrefs.xml'))/normref.list/normref[@id=$normref]/stdref/stdnumber"/>
										</xsl:variable>
										<xsl:variable name="orgname">
											<xsl:value-of select="document(concat($path, '../../../data/basic/normrefs.xml'))/normref.list/normref[@id=$normref]/stdref/orgname"/>
										</xsl:variable>
										<!-- eliminate status info like TS, CD-TS, etc -->
										<xsl:variable name="orgname_cleaned">
											<xsl:choose>
												<xsl:when test="$orgname='ISO'">AISO</xsl:when>
												<xsl:when test="$orgname='ISO/TS'">AISO</xsl:when>
												<xsl:when test="$orgname='ISO/IEC'">BIEC</xsl:when>
												<xsl:when test="$orgname='IEC'">CIEC</xsl:when>
												<xsl:otherwise>D<xsl:value-of select="$orgname"/></xsl:otherwise>
											</xsl:choose>   
										</xsl:variable>
										
										<!-- Try to 'normalize' part and subpart numbers -->
											<!--<xsl:variable name="series" select="substring-before($part,'-')"/>-->
										
										<xsl:variable name="series">
											<xsl:choose>
												<xsl:when test="contains($part, '-')">
													<xsl:value-of select="substring-before($part,'-')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$part"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										
										
										
										
											<!-- normalize with longest possible series (10303) -->                    
										<xsl:variable name="series_norm">
											<xsl:choose>
												<xsl:when test="string-length($series)=1">0000<xsl:value-of select="$series"/></xsl:when>
												<xsl:when test="string-length($series)=2">000<xsl:value-of select="$series"/></xsl:when>
												<xsl:when test="string-length($series)=3">00<xsl:value-of select="$series"/></xsl:when>
												<xsl:when test="string-length($series)=4">0<xsl:value-of select="$series"/></xsl:when>
												<xsl:when test="string-length($series)=5"><xsl:value-of select="$series"/></xsl:when>
												<xsl:otherwise>00000</xsl:otherwise>
			<!--                    <xsl:call-template name="error_message">
														<xsl:with-param name="message">
															<xsl:value-of select="concat('Unsupported length of series number: ', $series, 'length: ', string-length($series))"/>
														</xsl:with-param>
													</xsl:call-template> -->
											</xsl:choose>
										</xsl:variable>
										
											<!-- normalize with longest possible part (4 digits) -->                    
										<xsl:variable name="part_norm">
											<xsl:choose>
												<xsl:when test="string-length($part_no)=1">-000<xsl:value-of select="$part_no"/></xsl:when> 
												<xsl:when test="string-length($part_no)=2">-00<xsl:value-of select="$part_no"/></xsl:when>
												<xsl:when test="string-length($part_no)=3">-0<xsl:value-of select="$part_no"/></xsl:when>
												<xsl:when test="string-length($part_no)=4">-<xsl:value-of select="$part_no"/></xsl:when>
												<xsl:otherwise>-0000</xsl:otherwise>
			<!--                    <xsl:call-template name="error_message">
														<xsl:with-param name="message">
															<xsl:value-of select="concat('Unsupported length of part number: ', $part_no, 'length: ', string-length($part_no))"/>
														</xsl:with-param>
													</xsl:call-template> -->
											</xsl:choose>
										</xsl:variable>
										<xsl:element name="part">
										<!-- Organization name -->
											<xsl:value-of select="$orgname_cleaned"/>-<xsl:value-of select="$series_norm"/><xsl:value-of select="$part_norm"/>
										</xsl:element>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="error_message">
									<xsl:with-param name="message">
										<xsl:value-of select="concat('Error 7: ', $normref, 'not found')"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<xsl:when test="contains($first,'resource:')">
						<xsl:variable name="resource" select="substring-after($first,'resource:')"/>						
						<xsl:variable name="resource_dir">
							<xsl:call-template name="resource_directory">
								<xsl:with-param name="resource" select="$resource"/>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:variable name="resource_xml" select="concat($resource_dir,'/resource.xml')"/>
						
						<!-- output the normative reference derived from the resource -->
						<xsl:element name="normref">
							<xsl:apply-templates select="document($resource_xml)/resource" mode="normref" />							
						</xsl:element>
						
					</xsl:when>
					
					<xsl:when test="contains($first,'resource:')">
						<xsl:variable name="resource" select="substring-after($first,'resource:')"/>
						<xsl:call-template name="output_resource_normref">
							<xsl:with-param name="resource_schema" select="$resource"/>
						</xsl:call-template>          
					</xsl:when>
				</xsl:choose>
	
				<xsl:call-template name="output_normrefs_rec">
					<xsl:with-param name="normrefs" select="$rest"/>
					<xsl:with-param name="resource_number" select="$resource_number"/>
				</xsl:call-template>
	
			</xsl:when>
			<xsl:otherwise/>
			<!-- end of recursion -->
		</xsl:choose>
	</xsl:template>


  <!-- given a list of normref nodes, add the ids of the normrefs to the
       normref_list, if not already a member. ids in normref_list are
       separated by a , -->
  <xsl:template name="get_normref">
    <xsl:param name="normref_nodes"/>
    <xsl:param name="normref_list"/>
    
    <xsl:variable name="normref_list_ret">
      <xsl:choose>
				<xsl:when test="$normref_nodes">

					<xsl:variable name="first">
						<xsl:choose>
							<xsl:when test="$normref_nodes[1]/@normref">
								<xsl:value-of select="concat('normref:',$normref_nodes[1]/@normref)"/>
							</xsl:when>
							<xsl:when test="$normref_nodes[1]/@resource.name">
								<xsl:value-of select="concat('resource:',$normref_nodes[1]/@resource.name)"/>
							</xsl:when>            
							<xsl:when test="$normref_nodes[1]/@resource.name">
								<xsl:value-of select="concat('resource:',$normref_nodes[1]/@resource.name)"/>
							</xsl:when>            
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="normref_list1">
						<xsl:call-template name="add_normref">
							<xsl:with-param name="normref" select="$first"/>
							<xsl:with-param name="normref_list" select="$normref_list"/>
						</xsl:call-template>
					</xsl:variable>

					<xsl:call-template name="get_normref">
						<xsl:with-param name="normref_nodes" select="$normref_nodes[position()!=1]"/>
						<xsl:with-param name="normref_list" select="$normref_list1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- end of recursion -->
					<xsl:value-of select="$normref_list"/>
				</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$normref_list_ret"/>
  </xsl:template>

	<xsl:template name="output_unpublished_normrefs">
		<xsl:param name="normrefs"/>

		<xsl:variable name="footnote">
			<xsl:choose>
				<xsl:when test="/resource/normrefs/normref/stdref[@published='n']">
					<xsl:value-of select="'y'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="output_unpublished_normrefs_rec">
						<xsl:with-param name="normrefs" select="$normrefs"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$footnote='y'">
			<p>
	<a name="tobepub">
		<sup>1)</sup> To be published.
	</a>      
			</p>
		</xsl:if>
	</xsl:template>


  <xsl:template name="output_unpublished_normrefs_rec">
    <xsl:param name="normrefs"/>

    <xsl:choose>
      <xsl:when test="$normrefs">
	<xsl:variable 
	    name="first"
	    select="substring-before(substring-after($normrefs,','),',')"/>
	<xsl:variable 
	    name="rest"
	    select="substring-after(substring-after($normrefs,','),',')"/>      
	
	<xsl:variable name="footnote">
		<xsl:choose>
			<xsl:when test="contains($first,'normref:')">
				<xsl:variable name="normref" select="substring-after($first,'normref:')"/>
				<xsl:choose>
					<xsl:when
							test="document(concat($path, '../../../data/basic/normrefs.xml'))/normref.list/normref[@id=$normref]/stdref[@published='n']">
						<xsl:value-of select="'y'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'n'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="contains($first,'resource:')">
				<xsl:variable name="resource" select="substring-after($first,'resource:')"/>
				
				<xsl:variable name="resource_dir">
					<xsl:call-template name="resource_directory">
						<xsl:with-param name="resource" select="$resource"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="resource_xml" select="concat($resource_dir,'/resource.xml')"/>

				<xsl:choose>
					<xsl:when test="document($resource_xml)/resource[@published='n']">
						<xsl:value-of select="'y'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'n'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<xsl:otherwise>
				<xsl:value-of select="'n'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$footnote='n'">
			<!-- only recurse if no unpublished standard found -->      
			<xsl:call-template name="output_unpublished_normrefs_rec">
				<xsl:with-param name="normrefs" select="$rest"/>
			</xsl:call-template>        
		</xsl:when>
		<xsl:otherwise>
			<!-- footnote found so stop -->
			<xsl:value-of select="'y'"/>
		</xsl:otherwise>
	</xsl:choose>
	
			</xsl:when>
			<xsl:otherwise>
	<!-- end of recursion -->
	<!-- <xsl:value-of select="$footnote"/> -->
	<xsl:value-of select="'n'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


  <!-- output a footnote to say that the normative reference has been
       derogated 
       Check the normative references in the nodule, then all the auto
       generated normrefs. These should be passed as a parameter the value of
       which is deduced by: template name="normrefs_list"
  -->
	<xsl:template name="output_derogated_normrefs">
		<xsl:param name="current_resource"/>
		<xsl:param name="normrefs"/>

    <xsl:variable name="footnote">
				<xsl:choose>
					<xsl:when 
							test="( string($current_resource/@status)='TS' or string($current_resource/@status)='IS') and ( string(./@status)='CD' or string(./@status)='CD-TS')">
						<xsl:value-of select="'y'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="( string($current_resource/@status)='TS' or string($current_resource/@status)='IS')">
							<xsl:call-template name="output_derogated_normrefs_rec">
								<xsl:with-param name="normrefs" select="$normrefs"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$footnote='y'">
				<p>
		<a name="derogation">
			2) Reference applicable during ballot or review period.
		</a>      
				</p>
			</xsl:if>
	</xsl:template>


	<xsl:template name="output_derogated_normrefs_rec">
		<xsl:param name="normrefs"/>

		<xsl:choose>
			<xsl:when test="$normrefs">
				<xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>      
	
				<xsl:variable name="footnote">
					<xsl:choose>
						<!-- ASSUMING THAT ALL NORMREFS IN normrefs.xml ARE
					 PUBLISHED THERE FORE CANNOT BE DEROGATED 

			<xsl:when test="contains($first,'normref:')">
			<xsl:variable 
			name="normref" 
			select="substring-after($first,'normref:')"/>
			<xsl:choose>
			<xsl:when
			test="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
			<xsl:value-of select="'y'"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="'n'"/>
			</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
						-->

						<xsl:when test="contains($first,'resource:')">
							<xsl:variable  name="resource" select="substring-after($first,'resource:')"/>
							
							<xsl:variable name="resource_dir">
								<xsl:call-template name="resource_directory">
									<xsl:with-param name="resource" select="$resource"/>
								</xsl:call-template>
							</xsl:variable>

							<xsl:variable name="resource_xml" select="concat($resource_dir,'/resource.xml')"/>

							<xsl:variable name="resource_status" select="string(document($resource_xml)/resource/@status)"/>
								<xsl:choose>
									<xsl:when test="$resource_status='CD-TS' or $resource_status='CD'">
										<xsl:value-of select="'y'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'n'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>

							<xsl:otherwise>
								<xsl:value-of select="'n'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

				<xsl:choose>
					<xsl:when test="$footnote='n'">
						<!-- only recurse if no unpublished standard found -->      
						<xsl:call-template name="output_derogated_normrefs_rec">
							<xsl:with-param name="normrefs" select="$rest"/>
						</xsl:call-template>        
					</xsl:when>
					<xsl:otherwise>
						<!-- footnote found so stop -->
						<xsl:value-of select="'y'"/>
					</xsl:otherwise>
				</xsl:choose>
	
			</xsl:when>
			<xsl:otherwise>
				<!-- end of recursion -->
				<!-- <xsl:value-of select="$footnote"/> -->
				<xsl:value-of select="'n'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



  <!-- given a list of abbreviation.inc nodes, add the ids of the normrefs to the
       normref_list, if not already a member. ids in normref_list are
       separated by a , -->
	<xsl:template name="get_normrefs_from_abbr">
		<xsl:param name="abbrvinc_nodes"/>
		<xsl:param name="normref_list"/>
		
		<xsl:variable name="normref_list_ret">
			<xsl:choose>
				<xsl:when test="$abbrvinc_nodes">
					<xsl:variable name="abbr.inc" select="$abbrvinc_nodes[1]/@linkend"/>

					<xsl:variable name="abbr" select="document(concat($path, '../../../data/basic/abbreviations.xml'))/abbreviation.list/abbreviation[@id=$abbr.inc]"/>

					<xsl:variable name="first">
						<xsl:choose>
							<xsl:when test="$abbr/term.ref/@normref">
								<xsl:value-of select="concat('normref:',$abbr/term.ref/@normref)"/>
							</xsl:when>
							<xsl:when test="$abbr/term.ref/@resource.name">
								<xsl:value-of select="concat('resource:',$abbr/term.ref/@resource.name)"/>
							</xsl:when>            
							<xsl:when test="$abbr/term.ref/@resource.name">
								<xsl:value-of select="concat('resource:',$abbr/term.ref/@resource.name)"/>
							</xsl:when>            
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="normref_list1">
						<xsl:call-template name="add_normref">
							<xsl:with-param name="normref" select="$first"/>
							<xsl:with-param name="normref_list" select="$normref_list"/>
						</xsl:call-template>
					</xsl:variable>

					<xsl:call-template name="get_normrefs_from_abbr">
						<xsl:with-param name="abbrvinc_nodes" select="$abbrvinc_nodes[position()!=1]"/>
						<xsl:with-param name="normref_list" select="$normref_list1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- end of recursion -->
					<xsl:value-of select="$normref_list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="$normref_list_ret"/>

	</xsl:template>


	
	<!-- END Normative References -->
	<!-- ================== -->
	
	
	
	
	
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


	<!-- from xsl/common.xsl -->
  <!-- given the name of a schema, check to see whether it has bee
       included in the repository_index.xml file as an
       integrated resource
       Return true or if not found, an error message.
       -->

  <xsl:template name="check_resource_exists">
    <xsl:param name="schema"/>

    <!-- the name of the resource directory should be in lower case -->

    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="lschema" select="translate($schema,$UPPER,$LOWER)"/>

    <xsl:variable name="ret_val">

        <xsl:choose>

          <xsl:when

            test="document('../repository_index.xml')/repository_index/resources/resource[@name=$lschema]">

            <xsl:value-of select="'true'"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of

              select="concat(' The schema ', $lschema,

                      ' is not identified as a resource in repository_index.xml')"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <xsl:value-of select="$ret_val"/>

  </xsl:template>



</xsl:stylesheet>