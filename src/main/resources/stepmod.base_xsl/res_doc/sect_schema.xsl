<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?> -->

<!--
$Id: sect_schema.xsl,v 1.4 2004/09/27 04:36:04 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output section 4 Information model as a web page
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:java="http://xml.apache.org/xalan/java" 
                version="1.0">

<!--   <xsl:import href="resource.xsl"/> -->
  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->

<!--   <xsl:import href="resource_clause.xsl"/>
  <xsl:import href="expressg_icon.xsl"/>  -->

  <xsl:output method="html"/>

    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="schema_expressg">
      <xsl:call-template name="make_schema_expressg_node_set"/>
    </xsl:variable>    

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource" mode="schema_resource"> <!-- called from stepmod2mn.resource.adoc.xsl  -->
  <xsl:param name="pos"/>

  <xsl:apply-templates select="schema[position()=$pos]">
    <xsl:with-param name="pos" select="$pos"/>
  </xsl:apply-templates>
</xsl:template>

  <!-- https://github.com/metanorma/stepmod2mn/issues/52 -->
  <!-- The source: https://github.com/metanorma/annotated-express/blob/main/data/documents/resources/fundamentals_of_product_description_and_support/sections/04-schemas.adoc -->
  <!-- <xsl:template name="insert_04-schemas_adoc">
    <xsl:variable name="content" select="java:org.metanorma.Util.getFileContentFromResources('04-schemas.adoc')"/>
    <xsl:value-of select="$content"/>
  </xsl:template> -->

</xsl:stylesheet>

