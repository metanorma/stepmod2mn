<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_a_short_names.xsl,v 1.27 2018/01/18 20:20:21 mike Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--   <xsl:import href="module.xsl"/> -->

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
<!--   <xsl:import href="module_clause.xsl"/> -->


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="annex_a">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'A'"/>
    <xsl:with-param name="heading" select="'MIM short names'"/>
    <xsl:with-param name="aname" select="'annexa'"/>
    <xsl:with-param name="informative" select="'normative'"/>
  </xsl:call-template>


  <!-- check that all the MIM entities have short names declared -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>

  <xsl:variable name="shortnames"
    select="/module/mim/shortnames/shortname"/>

  <!-- tt bug 6745 
    <xsl:for-each select="document($mim_xml)/express/schema/entity">
    <xsl:variable name="mim_entity" select="@name"/>
    <xsl:if test="not($shortnames[@entity=$mim_entity])">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error sn1: the MIM entity ',$mim_entity,
                  ' has not had a shortname declared.')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>-->

  <xsl:choose>
    <xsl:when test="mim/shortnames">
      <xsl:apply-templates select="mim/shortnames"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- <p> -->
        <!--
             Entity names in this part of ISO 10303 have been defined in other
             parts of ISO 10303. Requirements on the use of the short names are
             found in the implementation methods included in ISO 10303.  -->
             
        <!-- Entity names in this part of ISO 10303 have been defined in other
        ISO standards identified in Clause 2. Requirements on the use 
        of the short names are found in the implementation methods included in ISO
        10303.   MWD 2018-01-10 http://wikistep.org/bugzilla/show_bug.cgi?id=6456 -->
        
      <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">
        Requirements on the use of the short names are found in the implementation methods included in ISO 10303. EXPRESS entity names and the equivalent short names are available from:
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p> -->
        <!--
      <p class="note">
        <small>
          NOTE&#160;&#160;The EXPRESS entity names are available from
          the following URL:<br/>
        <xsl:variable name="UPPER"
          select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
        <xsl:variable name="LOWER"
          select="'abcdefghijklmnopqrstuvwxyz'"/>
        <xsl:variable name="mim_schema"
          select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
        <xsl:variable name="names_url"
          select="'http://www.tc184-sc4.org/Short_Names/'"/>
      </small>
    </p>
      <p class="center">
        <small>
          <a href="{$names_url}" target="_blank">
            <xsl:value-of select="$names_url"/>
          </a>
        </p>
       </small>
     </p> -->
      
      <p align="center">
        <small>
          <xsl:text>[align=center]</xsl:text>
          <xsl:text>&#xa;</xsl:text>
          <xsl:variable name="names_url" select="'http://standards.iso.org/iso/10303/tech/short_names/short-names.txt'"/>
          
          <!-- <a href="{$names_url}" target="_blank">
            <xsl:value-of select="$names_url"/>
          </a> -->
          
          <xsl:call-template name="insertParagraph">
            <xsl:with-param name="text">
              <xsl:call-template name="insertHyperlink">
                <xsl:with-param name="a">
                  <a href="{$names_url}" target="_blank">
                    <xsl:value-of select="$names_url"/>
                  </a>
                </xsl:with-param>
                <xsl:with-param name="asText">true</xsl:with-param>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
          
        </small>
      </p>
      
   </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="shortnames">

    <!--
    Table A.1 provides the short names for entities defined in the MIM of
    this part of ISO 10303. Requirements on the use of the short names are
    found in the implementation methods included in ISO 10303. 
         -->
    <!--<p>
      Table A.1 provides the short names for entities defined in the MIM of
      this part of ISO 10303.
    </p> 
    <p>
      Entity names in this part of ISO 10303 have been defined in Clause 5.2 and
      in other ISO standards identified in Clause 2.
    </p>
    <p>
      Requirements on the use of the short names are found in the
      implementation methods included in ISO 10303. 
    </p>
   
    <p class="note">
      <small>
        NOTE&#160;&#160;The EXPRESS entity names are available from
        the following URL:
      </small>
    </p> MWD 2018-01-18 http://wikistep.org/bugzilla/show_bug.cgi?id=6456 -->
  
  <!-- <p> -->
  <xsl:call-template name="insertParagraph">
    <xsl:with-param name="text">
      Requirements on the use of the short names are found in the implementation methods included in ISO 10303. EXPRESS entity names and the equivalent short names are available from:
    </xsl:with-param>
  </xsl:call-template>
  <!-- </p> -->
  
    <!-- <p align="center">
      <xsl:variable name="names_url"
    select="'http://standards.iso.org/iso/10303/tech/short_names/short-names.txt'"/>
      <small>
        <a href="{$names_url}"  target="_blank">
          <xsl:value-of select="$names_url"/>
      </a>
    </small>
  </p> -->
  
    <xsl:text>[align=center]</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:variable name="names_url" select="'http://standards.iso.org/iso/10303/tech/short_names/short-names.txt'"/>		
		<xsl:call-template name="insertParagraph">
			<xsl:with-param name="text">
			
				<xsl:call-template name="insertHyperlink">
					<xsl:with-param name="a">
						<a href="{$names_url}" target="_blank">
							<xsl:value-of select="$names_url"/>
						</a>
					</xsl:with-param>
					<xsl:with-param name="asText">true</xsl:with-param>
				</xsl:call-template>
				
			</xsl:with-param>
		</xsl:call-template>
  
 
  
  <!--<p align="center">
    <b>
      <a name="table_a1">
        Table A.1&#8212; MIM short names of entities 
      </a>
    </b>
  </p>
  <div align="center">
    <table border="1" cellspacing="0" cellpadding="7" width="537">
      <tr>
        <td>
          <b>Entity data types names</b>
        </td>
        <td>
          <b>Short names</b>
        </td>
      </tr>
      <xsl:apply-templates select="shortname">
        <xsl:sort select="@entity"/>
      </xsl:apply-templates>        
    </table>
  </div>   MWD 2018-01-18 http://wikistep.org/bugzilla/show_bug.cgi?id=6456  -->
</xsl:template>

<xsl:template match="shortname">
  <!-- <tr>
    <td width="77%" align="left"> -->
    <xsl:text>&#xa;</xsl:text>
      <!-- check that the entity exists in the mim -->
      <xsl:variable name="module_dir">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="../../../@name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="mim_entity" select="@entity"/>
      <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>
      <xsl:choose>
        <xsl:when
          test="document($mim_xml)/express/schema/entity[@name=$mim_entity]">
          <xsl:value-of select="$mim_entity"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$mim_entity"/>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error sn2: ',$mim_entity,' is not in mim.xml.')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    <!-- </td> -->
    <xsl:text>:: </xsl:text>
    <!-- <td width="23%" align="left"> -->
      <xsl:choose>
        <xsl:when test="string-length(@name)>0">
          <xsl:value-of select="@name"/>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error sn3: ',@entity,' shortname not declared.')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    <!-- </td>
  </tr> -->
  <xsl:text>&#xa;&#xa;</xsl:text>
</xsl:template>
  
</xsl:stylesheet>
