<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_d_mim_expg.xsl,v 1.14 2006/10/13 21:18:18 darla Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <!-- <xsl:import href="module_clause.xsl"/> -->


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="annex_d">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'D'"/>
    <xsl:with-param name="heading" 
      select="'MIM EXPRESS-G'"/>
    <xsl:with-param name="aname" select="'annexd'"/>
  </xsl:call-template>

  <!-- <xsl:variable name="href"
    select="concat('./5_mim',$FILE_EXT,'#mim_express')"/> -->
  <xsl:variable name="href">mim_express</xsl:variable>

  <xsl:choose>
    <!-- assume that if there is one image file that it is a schema diagram -->
    <xsl:when test="count(./arm/express-g/imgfile) = 1">
      <!-- <p> -->
      <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">
        The following diagram provides a graphical representation of the 
        MIM EXPRESS short listing defined in 
        <!-- Clause <a href="{$href}">5.2</a>.  -->
        &lt;&lt;<xsl:value-of select="$href"/>&gt;&gt;. 
        The diagrams are presented in EXPRESS-G.
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p>
      <p> -->
      <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">
        This annex contains a schema level representation of the 
        the Module Interpreted Model of this application module.
        It depicts the import of the constructs defined in the MIM schema
        of other application modules or in a schema of Common Resources documents,  
        in the MIM schema of this application module, through USE FROM
        statements.
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p>
      <p class="note">
        <small>
          NOTE&#160;&#160; -->
      <xsl:call-template name="insertNote">
        <xsl:with-param name="text">The schema level representation is partial. It
          does not present the MIM schema of modules that are indirectly imported. 
        </xsl:with-param>
      </xsl:call-template>
        <!-- </small>
      </p> -->
    </xsl:when>
    <xsl:otherwise>
      <!-- <p> -->
      <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">
        The following diagrams provide a graphical representation of the 
        MIM EXPRESS short listing defined in 
        <!-- Clause <a href="{$href}">5.2</a>.  -->
        &lt;&lt;<xsl:value-of select="$href"/>&gt;&gt;. 
        The diagrams are presented in EXPRESS-G.
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p>
      <p> -->
      <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">
        This annex contain two distinct representations of the Module
        Interpreted Model of this application module:
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p> -->
      <!-- <ul> -->
      <xsl:text>&#xa;</xsl:text>
        <!-- <li> -->
          <xsl:text>* </xsl:text>a schema level representation which depicts the import of the
          constructs defined in the MIM schema of other application modules or in a
          schema of Common Resources documents,  
          in the MIM schema of this application module, through USE FROM
          statements;
        <!-- </li> -->  
        <xsl:text>&#xa;&#xa;</xsl:text>
        <!-- <li> -->
          <xsl:text>* </xsl:text>an entity level representation which presents the EXPRESS constructs
          defined in the MIM schema of this application module and the
          references to imported constructs that are specialized or referred to
          by the constructs of the MIM schema of this application module.
        <!-- </li> --> 
        <xsl:text>&#xa;&#xa;</xsl:text>
      <!-- </ul> -->
      <xsl:text>&#xa;</xsl:text>
      <!-- <p class="note">
        <small>
          NOTE&#160;&#160; -->
      <xsl:call-template name="insertNote">
        <xsl:with-param name="text">Both these representations are partial. The schema
          level representation does not present the MIM schema of modules that are
          indirectly imported. 
          The entity level representation does not present the imported
          constructs that are not specialized or referred to by the constructs
          of the MIM schema of this application module. 
        </xsl:with-param>
      </xsl:call-template>
       <!--  </small>
      </p> -->
    </xsl:otherwise>
  </xsl:choose>

  <!-- <p> -->
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
    The EXPRESS-G graphical notation is defined in ISO 10303-11.
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->
  <!-- <a name="mimexpg"/> -->
  <!-- <xsl:text>[[mimexpg]]</xsl:text>
  <xsl:text>&#xa;</xsl:text> -->
  <xsl:apply-templates select="mim/express-g"/>
</xsl:template>
  
</xsl:stylesheet>
