package org.metanorma;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.TransformerFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * This class for the documents list extraction from publication index XML
 * @author Alexander Dyuzhev
 */
public class PublicationIndex {

    private String filename;

    private final String XPATH_RESOURCES = "//resource_docs/resource_doc";
    private final String XPATH_MODULES = "//modules/module";
    private final String XPATH_ALL = XPATH_RESOURCES + " | " + XPATH_MODULES;
    private static final String XML_EXTENSION = ".xml";
    public PublicationIndex(String xmlFilename) {
        this.filename = xmlFilename;
    }

    public List<String> getDocumentsPaths(String documentType) {
        if (documentType == null) {
            documentType = "";
        }
        List<String> documentsPaths = new ArrayList<>();
        try {
            InputStream xmlInputStream = new FileInputStream(filename);
            XMLReader rdr = XMLReaderFactory.createXMLReader();
            TransformerFactory factory = TransformerFactory.newInstance();
            factory.setURIResolver(new ClasspathResourceURIResolver());
            InputSource is = new InputSource(xmlInputStream);
            is.setSystemId(filename);

            DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = builderFactory.newDocumentBuilder();
            Document xmlDocument = builder.parse(is);
            XPath xPath = XPathFactory.newInstance().newXPath();
            String expression = XPATH_ALL;
            if (documentType.equals("resource_docs")) {
                expression = XPATH_RESOURCES;
            } else if (documentType.equals("modules")) {
                expression = XPATH_MODULES;
            }
            NodeList nodeList = (NodeList) xPath.compile(expression).evaluate(xmlDocument, XPathConstants.NODESET);

            for (int i = 0; i < nodeList.getLength(); i++) {
                Node node = nodeList.item(i);
                String name = node.getAttributes().getNamedItem("name").getNodeValue();
                String currentDocumentType = node.getNodeName(); // resource_doc or module
                String inputXmlFilename = currentDocumentType;
                if (inputXmlFilename.equals("resource_doc")) {
                    inputXmlFilename = "resource";
                }
                // resource.xml or module.xml
                inputXmlFilename += XML_EXTENSION;

                Path inputXmlFilePath = Paths.get(currentDocumentType + "s", name, inputXmlFilename);

                documentsPaths.add(inputXmlFilePath.toString());
            }
        } catch (Exception ex) {
            System.err.println("Can't process the publication index '" + filename + "':" + ex);
        }
        return documentsPaths;
    }
}
