package org.metanorma;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;

public class XMLUtils {

    public static String processLinearizedXML(String xmlFilePath){
        try {
            InputStream xmlInputStream = null;

            File fXMLin = new File(xmlFilePath);

            if (Util.isUrl(xmlFilePath)) {
                try {
                    URL url = new URL(xmlFilePath);
                    xmlInputStream = url.openStream();
                } catch (IOException ex) {} //checked above


            } else { try {
                // in case of local file
                xmlInputStream = new FileInputStream(fXMLin);
            } catch (FileNotFoundException ex) { }//checked above
            }

            // to skip validating
            //found here: https://moleshole.wordpress.com/2009/10/08/ignore-a-dtd-when-using-a-transformer/
            XMLReader rdr = XMLReaderFactory.createXMLReader();

            /*rdr.setEntityResolver(new EntityResolver() {
                @Override
                public InputSource resolveEntity(String publicId, String systemId) throws SAXException, IOException {
                    if (systemId.endsWith(".dtd")) {
                            //StringReader stringInput = new StringReader(" ");
                            StringReader stringInput = new StringReader(systemId);
                            //StringReader stringInput = new StringReader("file:///C:/Delete/test.dtd");
                            //return new InputSource(stringInput);
                            String dtd = "C:/Delete/test.dtd";
                            return new InputSource(new FileInputStream(dtd));
                    }
                    else {
                            return null; // use default behavior
                    }
                }
            });*/

            TransformerFactory factory = TransformerFactory.newInstance();
            factory.setURIResolver(new ClasspathResourceURIResolver());
            Transformer transformer = factory.newTransformer();
            //Source src = new StreamSource(fXMLin);
            //Source src = new SAXSource(rdr, new InputSource(new FileInputStream(fXMLin)));
            InputSource is = new InputSource(xmlInputStream);
            is.setSystemId(xmlFilePath);
            Source src = new SAXSource(rdr, is);
            //Source src = new StreamSource(is);

            // linearize XML
            Source srcXSLidentity = new StreamSource(Util.getStreamFromResources(stepmod2mn.class.getClassLoader(), "linearize.xsl"));

            transformer = factory.newTransformer(srcXSLidentity);

            StringWriter resultWriteridentity = new StringWriter();
            StreamResult sridentity = new StreamResult(resultWriteridentity);
            transformer.transform(src, sridentity);
            String xmlidentity = resultWriteridentity.toString();
            return xmlidentity;
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
        return "";
    }

    public static String getOutputAdocPath(String argOutputPath, String inputXmlFile) {
        String outAdocFile = "";
        if (argOutputPath.isEmpty()) {
            // if the parameter '--output' is missing,
            // then save ADOC result in then input folder
            Path outAdocPath = Paths.get((new File(inputXmlFile)).getParent(), Constants.DOCUMENT_ADOC);
            outAdocFile = outAdocPath.toString();
        } else {
            // get linearized XML with default attributes substitution from DTD
            String linearizedXML = XMLUtils.processLinearizedXML(inputXmlFile);
            String part = XMLUtils.getTextByXPath(linearizedXML, "*/@part");
            if (part.isEmpty()) {
                part = "unknown";
            }

            String folderDocumentName = "iso-10303-" +  part;

            Path outAdocPath = Paths.get(argOutputPath, folderDocumentName, Constants.DOCUMENT_ADOC);
            outAdocFile = outAdocPath.toString();
        }
        return outAdocFile;
    }

    public static String getOutputAdocPath2(String argOutputPath, String inputXmlFile) {
        String outAdocFile = "";
        if (argOutputPath.isEmpty()) {
            // if the parameter '--output' is missing,
            // then save ADOC result in then input folder
            Path outAdocPath = Paths.get((new File(inputXmlFile)).getParent(), Constants.DOCUMENT_ADOC);
            outAdocFile = outAdocPath.toString();
        } else {
            String folderType = "other";
            if (inputXmlFile.toLowerCase().endsWith("resource.xml")) {
                folderType = "resources";
            } else if (inputXmlFile.toLowerCase().endsWith("module.xml")) {
                folderType = "modules";
            }
            String folderDocumentName = new File(inputXmlFile).getParentFile().getName();
            // example: ...documents/resources/fundamentals_of_product_description_and_support/document.adoc
            Path outAdocPath = Paths.get(argOutputPath, folderType, folderDocumentName, Constants.DOCUMENT_ADOC);
            outAdocFile = outAdocPath.toString();
        }
        return outAdocFile;
    }

    public static String getRootElement (String xml) {
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = null;
            db = dbf.newDocumentBuilder();

            InputSource is = new InputSource();
            is.setCharacterStream(new StringReader(xml));

            Document doc = db.parse(is);
            Element root = doc.getDocumentElement();
            String rootName = root.getNodeName();
            return rootName;
        } catch (SAXException | IOException | ParserConfigurationException e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
        return "";
    }

    public static String getTextByXPath(String xml, String expression) {
        try {
            InputSource is = new InputSource();
            is.setCharacterStream(new StringReader(xml));

            DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = builderFactory.newDocumentBuilder();
            Document xmlDocument = builder.parse(is);
            XPath xPath = XPathFactory.newInstance().newXPath();

            NodeList nodeList = (NodeList) xPath.compile(expression).evaluate(xmlDocument, XPathConstants.NODESET);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < nodeList.getLength(); i++) {
                Node node = nodeList.item(i);
                sb.append(node.getNodeValue());
            }
            return sb.toString();
        } catch (Exception ex) {
            System.err.println("Can't retrieve the text by XPath '" + expression + "':" + ex);
        }
        return "";
    }
}
