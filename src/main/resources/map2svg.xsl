<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mml="http://www.w3.org/1998/Math/MathML" 
		xmlns:tbx="urn:iso:std:iso:30042:ed-1" 
		xmlns:xalan="http://xml.apache.org/xalan" 
		xmlns:java="http://xml.apache.org/xalan/java" 
		xmlns:metanorma-class="xalan://com.metanorma.RegExEscaping"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:str="http://exslt.org/strings"
		exclude-result-prefixes="mml tbx  xalan java metanorma-class str svg" 
		version="1.0">
	<!-- xmlns:xlink="http://www.w3.org/1999/xlink"  -->
	<xsl:output method="xml" encoding="UTF-8"/>
			
	<xsl:param name="path" />
	<xsl:param name="image"/>
	
   <xsl:attribute-set name="shapeAttributes">
      <xsl:attribute name="onmouseout">this.style.opacity=0</xsl:attribute>
      <xsl:attribute name="onmouseover">this.style.opacity=1</xsl:attribute>
      <xsl:attribute name="style">opacity: 0; fill: rgb(33, 128, 255); fill-opacity: 0.3; stroke: rgb(0, 128, 255); stroke-width: 1px; stroke-linecap: butt; stroke-linejoin: miter; stroke-opacity: 1;</xsl:attribute>
   </xsl:attribute-set>
   
	<xsl:template match="/">
		<xsl:if test="count(//img) &gt; 1">
			<xsl:message>Error: count img = <xsl:value-of select="count(//img)"/></xsl:message>
		</xsl:if>
		<xsl:if test="normalize-space($image) != '' and count(//img[@src = $image]) != 1">
			<xsl:message>Error: count img '<xsl:value-of select="$image"/>' = <xsl:value-of select="count(//img[@src = $image])"/></xsl:message>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="img">
		<xsl:choose>
			<xsl:when test="normalize-space($image) != ''">
				<!-- process only specified image -->
				<xsl:if test="@src = $image">
					<xsl:apply-templates select="." mode="process"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="process"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="img" mode="process">
	
		<xsl:variable name="image_source" select="concat($path, @src)"/>
		<xsl:variable name="image_type">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="string" select="$image_source"/>
				<xsl:with-param name="delimiter" select="'.'"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- read gif width and height -->
		<xsl:variable name="file" select="java:java.io.File.new($image_source)"/>
		<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
		<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
		<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
		
		<xsl:if test="number($width) != $width">
			<xsl:message>Unknown width=<xsl:value-of select="$width"/></xsl:message>
		</xsl:if>
		<xsl:if test="number($height) != $height">
			<xsl:message>Unknown height=<xsl:value-of select="$height"/></xsl:message>
		</xsl:if>
		
		<xsl:variable name="filePath" select="java:toPath($file)"/>
		<xsl:variable name="fileContent" select="java:java.nio.file.Files.readAllBytes($filePath)"/>
		<xsl:variable name="encoder" select="java:java.util.Base64.getEncoder()"/>
		<xsl:variable name="base64String" select="java:encodeToString($encoder, $fileContent)"/>
		
		<xsl:if test="normalize-space($base64String) = ''">
			<xsl:message>Error: empty base64 string.</xsl:message>
		</xsl:if>
		
		<!-- xmlns:xlink="http://www.w3.org/1999/xlink" -->
		<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" 
		x="0px" y="0px" viewBox="0 0 {$width} {$height}" width="{$width}" height="{$height}" style="enable-background:new 0 0 595.28 841.89;" xml:space="preserve">
			<!-- <style type="text/css">.st0{fill:#FFFFFF;stroke:#000000;stroke-miterlimit:10;opacity:0}</style> -->
			<!-- 'xlink:href' changed to 'href' for https://github.com/metanorma/stepmod2mn/issues/17, https://github.com/metanorma/annotated-express/issues/21  -->
			<image style="overflow:visible;" width="{$width}" height="{$height}" href="data:image/{$image_type};base64,{$base64String}" ><!-- transform="matrix(1 0 0 1 114 263.8898)" -->
			</image>
			<xsl:apply-templates />
		</svg>
	</xsl:template>

	<!-- <img.area shape="rect" coords="157,98,305,139" href="../../resources/support_resource_schema/support_resource_schema.xml" /> -->
	<!-- <img.area shape="rect" coords="x1,y1,y2,y3"> 
	corresponds to 
	<rect x="x1" y="y1" fill="#fff" opacity="0" width="x2-x1" height="y2-y1" />
	-->
	
	<xsl:template match="img.area">
		<xsl:message>Error: Unknown area '<xsl:value-of select="@shape"/>'</xsl:message>
	</xsl:template>
	
	<xsl:template match="img.area[@shape = 'rect']">
		<xsl:variable name="coords" select="str:split(@coords,',')"/>
		<xsl:variable name="x1" select="$coords[1]"/>
		<xsl:variable name="y1" select="$coords[2]"/>
		<xsl:variable name="x2" select="$coords[3]"/>
		<xsl:variable name="y2" select="$coords[4]"/>
		
		<xsl:variable name="number"><xsl:number count="img.area"/></xsl:variable>
		
		<!-- <a xlink:href="{@href}" xmlns="http://www.w3.org/2000/svg"> class="st0" -->
		<a href="{$number}" xmlns="http://www.w3.org/2000/svg">
			<rect x="{$x1}" y="{$y1}" width="{$x2 - $x1}" height="{$y2 - $y1}" xsl:use-attribute-sets="shapeAttributes"/>
		</a>
	</xsl:template>

	<xsl:template match="img.area[@shape = 'poly' or @shape = 'polygon' or @shape = 'POLYGON']">
		<xsl:variable name="number"><xsl:number count="img.area"/></xsl:variable>
		
		<!-- <a xlink:href="{@href}" xmlns="http://www.w3.org/2000/svg"> class="st0" -->
		<a href="{$number}" xmlns="http://www.w3.org/2000/svg">
			<polygon points="{@coords}" xsl:use-attribute-sets="shapeAttributes"/>
		</a>
	</xsl:template>


	<xsl:template match="img.area[@shape = 'circle']">
		<xsl:variable name="coords" select="str:split(@coords,',')"/>
		<xsl:variable name="cx" select="$coords[1]"/>
		<xsl:variable name="cy" select="$coords[2]"/>
		<xsl:variable name="r" select="$coords[3]"/>
		
		<xsl:variable name="number"><xsl:number count="img.area"/></xsl:variable>
		
		<!-- <a xlink:href="{@href}" xmlns="http://www.w3.org/2000/svg"> class="st0"-->
		<a href="{$number}" xmlns="http://www.w3.org/2000/svg">
			<circle cx="{$cx}" cy="{$cy}" r="{$r}" xsl:use-attribute-sets="shapeAttributes"/>
		</a>
	</xsl:template>
	
	<xsl:template match="img.area[@shape = 'ellipse']">
		<xsl:variable name="coords" select="str:split(@coords,',')"/>
		<xsl:variable name="cx" select="$coords[1]"/>
		<xsl:variable name="cy" select="$coords[2]"/>
		<xsl:variable name="rx" select="$coords[3]"/>
		<xsl:variable name="ry" select="$coords[3]"/>
		
		<xsl:variable name="number"><xsl:number count="img.area"/></xsl:variable>
		
		<!-- <a xlink:href="{@href}" xmlns="http://www.w3.org/2000/svg"> class="st0" -->
		<a href="{$number}" xmlns="http://www.w3.org/2000/svg">
			<ellipse cx="{$cx}" cy="{$cy}" rx="{$rx}" ry="{$ry}" xsl:use-attribute-sets="shapeAttributes"/>
		</a>
	</xsl:template>
	
	<xsl:template name="substring-after-last">
		<xsl:param name="string" />
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($string, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="substring-after($string, $delimiter)" />
					<xsl:with-param name="delimiter" select="$delimiter" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
</xsl:stylesheet>