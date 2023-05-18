<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_6_refdata.xsl,v 1.1 2006/05/18 16:17:23 dmprice Exp $
  Author:  David Price, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to OSJTF under contract.
  Purpose:
     
-->
<!-- Updated: Alexander Dyuzhev, for stepmod2mn tool -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>

  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module" mode="refdata_module">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'6 Module reference data'"/>
    <xsl:with-param name="aname" select="'refdata'"/>
  </xsl:call-template>

	  <xsl:choose>
    <xsl:when test="refdata">
		
		<!-- <p> -->
    <xsl:call-template name="insertParagraph">
      <xsl:with-param name="text">Implementations of this part of ISO 10303 shall make use of the capability to classify an 
       entity type using <b>Classification_assignment</b> (see ISO 10303-1114), <b>Class</b> (see ISO 10303-1070) and <b>External_class</b> (see ISO 10303-1275).
       This annex contains a subclause for each entity type defined in or used by this part of ISO 10303 for which that capability
       shall be applied. The specified Uniform Resource Identifier (URI) is used to identify each class.
     </xsl:with-param>
   </xsl:call-template>
   <!-- </p> -->

    <!-- <p class="note">
      <small>
        NOTE-1 &#160;&#160; -->
    <xsl:call-template name="insertNote">
      <xsl:with-param name="text">A URI can be a HTTP URI. However, the use of a HTTP URI does not necessarily mean that a HTTP GET obtains a representation of the specified resource. Even if a representation is obtained, that representation is not necessarily part of the standard.
      </xsl:with-param>
    </xsl:call-template>
     <!-- </small>
    </p> -->

     <!-- <p> -->
     <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">For the purpose of diagramming possible classifications of EXPRESS entity types, UML 1.4 or later class diagrams with stereotypes
        are used. The W3C OWL Web Ontology Language is used to represent the
        classes that may be applied to an EXPRESS entity type both in the diagrams and as example OWL files.
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p> -->

    <!-- <p class="note">
      <small>
        NOTE-2 &#160;&#160; -->
      <xsl:call-template name="insertNote">
        <xsl:with-param name="text">The standards related to the specification of reference data are:
				<!-- <ul> -->
        <xsl:text>&#xa;&#xa;</xsl:text>
				<!-- <li> --><xsl:text>* </xsl:text>the  <a target="_blank" href="http://www.omg.org/technology/documents/formal/uml.htm">UML 2 specification</a> is available from the OMG Web site;<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
				<!-- <li> --><xsl:text>* </xsl:text>the <a target="_blank" href="http://www.omg.org/cgi-bin/doc?formal/05-04-01">ISO UML 1.4.2 specification</a> published as ISO/IEC 19501:2005(E) is available from the OMG Web site
and from the <a href="http://www.iso.org">ISO</a> Web site;<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
				<!-- <li> --><xsl:text>* </xsl:text>the <a target="_blank" href="http://www.w3.org/TR/owl-ref/">OWL Web Ontology Language Reference</a> is available from the W3C Web site.<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
				<!-- </ul> -->
        <xsl:text>&#xa;&#xa;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
     <!-- </small>
    </p> -->

    <!-- <p> -->
     <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">The diagram notation is interpreted as follows:
        </xsl:with-param>
    </xsl:call-template>
    <!-- </p> -->
    
       <!-- <ul> -->
       <xsl:text>&#xa;</xsl:text>
      <!-- <li> --><xsl:text>* </xsl:text>the <code>&lt;&lt;expressEntityType&gt;&gt;</code> stereotype applied to a UML Class denotes an EXPRESS entity type;<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
      <!-- <li> --><xsl:text>* </xsl:text>the <code>&lt;&lt;owlClass&gt;&gt;</code> stereotype applied to a UML Class denotes the related class(es);<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
      <!-- <li> --><xsl:text>* </xsl:text>if all OWL classes on a diagram have the same namespace it may be omitted, otherwise the XML namespace of the OWL ontology
            containing each class is
             represented as the UML Package name which appears under the class name enclosed in parentheses;<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
       <!-- <li> --><xsl:text>* </xsl:text>the <code>&lt;&lt;classificationAssignment&gt;&gt;</code> stereotype applied to a UML Generalization denotes
			       the fact that the EXPRESS entity type can be classified
             using the more specific class;<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
       <!-- <li> --><xsl:text>* </xsl:text>the <code>&lt;&lt;disjointWith&gt;&gt;</code> stereotype applied to a UML constraint note is included where appropriate
			     to specify the set of OWL classes are mutually exclusive<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
       <!-- <li> --><xsl:text>* </xsl:text>the OWL <code>subClassOf</code> relationship between OWL classes is denoted using unstereotyped generalizations
			      between the stereotyped UML classes;<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
        <!-- <li> --><xsl:text>* </xsl:text>no other UML, EXPRESS or OWL concepts appear in these diagrams.<xsl:text>&#xa;&#xa;</xsl:text><!-- </li> -->
        <!-- </ul>		 -->
        <xsl:text>&#xa;&#xa;</xsl:text>
		
      <xsl:apply-templates select="refdata"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- <p> -->
      <xsl:call-template name="insertParagraph">
        <xsl:with-param name="text">
        An Application module reference data has not been provided.
        </xsl:with-param>
      </xsl:call-template>
      <!-- </p> -->
    </xsl:otherwise>
  </xsl:choose>

	</xsl:template>


</xsl:stylesheet>
