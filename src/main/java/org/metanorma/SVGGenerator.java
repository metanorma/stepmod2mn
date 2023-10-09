package org.metanorma;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class SVGGenerator {

    final String SVG_EXTENSION = ".svg";

    public void generateSVG(String xmlFile, String image, String outPath, boolean isSVGmap) {
        try {
            String content = new String(Files.readAllBytes(Paths.get(xmlFile)));
            if (content.contains("img.area")) {
                String folder = new File(xmlFile).getParent() + File.separator;
                //String svgFilename = xmlFile.substring(0, xmlFile.length() - XML_EXTENSION.length()) + SVG_EXTENSION;
                String svgFilename = Util.changeFileExtension(xmlFile, SVG_EXTENSION);
                if (outPath != null && !outPath.isEmpty()) {
                    if (!(outPath.toLowerCase().endsWith(SVG_EXTENSION) || outPath.toLowerCase().endsWith(Constants.XML_EXTENSION))) { // if folder

                        String xmlFilename = Paths.get(xmlFile).getFileName().toString();
                        svgFilename = Util.changeFileExtension(xmlFilename, SVG_EXTENSION);

                        String schemaName = "";
                        if (!isSVGmap) { //no need to add schamaName for [.svgmap] SVG
                            schemaName = new File(xmlFile).getParentFile().getName();
                            Files.createDirectories(Paths.get(outPath, schemaName));
                        }

                        svgFilename = Paths.get(outPath, schemaName, svgFilename).toString();
                    } else {
                        svgFilename = outPath;
                        String parentFolder = new File(svgFilename).getParent();
                        if (parentFolder != null && !parentFolder.isEmpty()) {
                            Files.createDirectories(Paths.get(parentFolder));
                        }
                    }
                }
                System.out.println("Generate SVG file for " + xmlFile + "...");


                // get linearized XML with default attributes substitution from DTD
                String linearizedXML = XMLUtils.processLinearizedXML(xmlFile);
                // load linearized xml
                Source src = new StreamSource(new StringReader(linearizedXML));

                Source srcXSL = new StreamSource(Util.getStreamFromResources(getClass().getClassLoader(), "map2svg.xsl"));

                TransformerFactory factory = TransformerFactory.newInstance();
                Transformer transformer = factory.newTransformer();
                transformer = factory.newTransformer(srcXSL);

                transformer.setParameter("path", folder);
                if (image != null) {
                    transformer.setParameter("image", image);
                }

                StringWriter resultWriter = new StringWriter();
                StreamResult sr = new StreamResult(resultWriter);

                transformer.transform(src, sr);
                String xmlSVG = resultWriter.toString();
                new File(svgFilename).getParentFile().mkdirs();
                try (
                        BufferedWriter writer = Files.newBufferedWriter(Paths.get(svgFilename))) {
                    writer.write(xmlSVG);
                }
                System.out.println("SVG saved in " + svgFilename + ".");
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
