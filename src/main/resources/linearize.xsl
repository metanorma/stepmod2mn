<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mml="http://www.w3.org/1998/Math/MathML" 
		xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:xalan="http://xml.apache.org/xalan" 
		xmlns:java="http://xml.apache.org/xalan/java" 
		xmlns:java_char="http://xml.apache.org/xalan/java/java.lang.Character" 
		exclude-result-prefixes="mml tbx xlink xalan java" 
		version="1.0">

	<xsl:preserve-space elements="code mml:*"/>
	
	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:template match="/">
	
		<xsl:variable name="xml_step1">
			<xsl:apply-templates select="." mode="step1"/>
		</xsl:variable>
	
		<xsl:apply-templates select="xalan:nodeset($xml_step1)/*"/>
	
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="step1">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove empty p -->
	<xsl:template match="p[not(text()) or text() = '']" mode="step1"/>
	
	
	<xsl:template match="@*|node()">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="text()[not(parent::code or parent::mml:* or parent::b or parent::B or parent::i or parent::I or parent::tt or parent::TT or parent::sup or parent::SUP or parent::sub or parent::SUB)]">
		<xsl:choose>
			<xsl:when test="contains(., '&#xa;')">
				<xsl:variable name="text_" select="translate(., '&#xa;&#x9;', '  ')"/>
				<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($text_),' +',' ')"/>
				<xsl:if test="normalize-space($text) != ''">
					<xsl:call-template name="trimSpaces">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="."/> -->
				<xsl:call-template name="trimSpaces"/>
			</xsl:otherwise>
		</xsl:choose>		
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
		
		<!-- <xsl:choose>
			<xsl:when test="(not(preceding-sibling::*) and not(following-sibling::*))">
				<xsl:value-of select="normalize-space($text)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:value-of select="$text_righttrim"/>
	</xsl:template>
	
	<xsl:template match="b | B | i | I | tt | TT | sub | SUB | sup | SUP">
		<xsl:call-template name="processUnconstrainedFormatting"/>
	</xsl:template>
	
	<xsl:template name="processUnconstrainedFormatting">
		<xsl:variable name="unconstrained_formatting"><xsl:call-template name="is_unconstrained_formatting"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$unconstrained_formatting = 'true'">
				<!-- create element b2, i2, sup2, etc. -->
				<xsl:element name="{local-name()}2">
					<xsl:apply-templates select="@*"/>
					<xsl:apply-templates />
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