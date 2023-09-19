package org.metanorma;

import java.io.*;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * This class for the conversion of an NISO/ISO XML file to Metanorma XML or AsciiDoc
 */
public class stepmod2mn {

    static final String CMD = "java -Xss5m -jar stepmod2mn.jar <resource or module or publication index xml file> [options -o, -v, -b <path> -t <type>]";
    static final String CMD_SVGscope = "java -jar stepmod2mn.jar <start folder to process xml maps files> --svg";
    static final String CMD_SVG = "java -jar stepmod2mn.jar --xml <Express Imagemap XML file path> --image <Image file name> [--svg <resulted SVG map file or folder>] [-v]";
    
    static final String INPUT_NOT_FOUND = "Error: %s file '%s' not found!";    
    static final String INPUT_PATH_NOT_FOUND = "Error: %s path '%s' not found!";    
    static final String XML_INPUT = "XML";    
    static final String INPUT_LOG = "Input: %s (%s)";    
    static final String OUTPUT_LOG = "Output: %s (%s)";

    static final String SVG_EXTENSION = ".svg";
    static final String XML_EXTENSION = ".xml";
    static boolean DEBUG = false;

    static String VER = Util.getAppVersion();
    
    static final Options optionsInfo = new Options() {
        {
            addOption(Option.builder("v")
                    .longOpt("version")
                    .desc("display application version")
                    .required(true)
                    .build());
        }
    };
    
    static final Options optionsSVG = new Options() {
        {
            addOption(Option.builder("x")
                    .longOpt("xml")
                    .desc("Express Imagemap XML file")
                    .hasArg()
                    .required()
                    .build());
            addOption(Option.builder("i")
                    .longOpt("image")
                    .desc("Image file (.gif, .jpg, .png, etc.)")
                    .hasArg()
                    .required()
                    .build());
            addOption(Option.builder("s")
                    .longOpt("svg")
                    .desc("resulted SVG map file or folder")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("v")
                    .longOpt("version")
                    .desc("display application version")
                    .required(false)
                    .build());            
        }
    };
    
    static final Options optionsSVGscope = new Options() {
        {
            addOption(Option.builder("svg")
                    .longOpt("svg")
                    .desc("generate SVG files")
                    .hasArg(false)
                    .required()
                    .build());   
            addOption(Option.builder("v")
                    .longOpt("version")
                    .desc("display application version")
                    .required(false)
                    .build());
            addOption(Option.builder("o")
                    .longOpt("output")
                    .desc("output directory")
                    .hasArg()
                    .required(false)
                    .build());
        }
    };

    static final Options options = new Options() {
        {
            addOption(Option.builder("o")
                    .longOpt("output")
                    .desc("output file name (for one .xml input file) or directory")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("b")
                    .longOpt("boilerplatepath")
                    .desc("path to boilerplate text storage folder")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("t")
                    .longOpt("type")
                    .desc("documents types: resource_docs or modules (for publication index only)")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("v")
                    .longOpt("version")
                    .desc("display application version")
                    .required(false)
                    .build());            
        }
    };

    static final String USAGE = getUsage();

    static final String TMPDIR = System.getProperty("java.io.tmpdir");
    
    static final Path tmpfilepath  = Paths.get(TMPDIR, UUID.randomUUID().toString());
    
    String resourcePath = "";
    
    String boilerplatePath = "";

    /**
     * Main method.
     *
     * @param args command-line arguments
     * @throws org.apache.commons.cli.ParseException
     */
    public static void main(String[] args) throws ParseException {

        CommandLineParser parser = new DefaultParser();
               
        boolean cmdFail = false;

        // optionsInfo
        try {
            CommandLine cmdInfo = parser.parse(optionsInfo, args);
            printVersion(cmdInfo.hasOption("version"));            
        } catch (ParseException exp) {
            cmdFail = true;
        }// END optionsInfo

        // optionsSVG
        if(cmdFail) {
            try {
                CommandLine cmd = parser.parse(optionsSVG, args);
                System.out.print("stepmod2mn ");
                printVersion(cmd.hasOption("version"));
                
                String xmlIn = cmd.getOptionValue("xml");
                String imageIn = cmd.getOptionValue("image");
                //get filename from path
                imageIn = Paths.get(imageIn).getFileName().toString();

                try {
                    stepmod2mn app = new stepmod2mn();
                    app.generateSVG(xmlIn, imageIn, cmd.getOptionValue("svg"), false);
                    System.out.println("End!");

                } catch (Exception e) {
                    e.printStackTrace(System.err);
                    System.exit(Constants.ERROR_EXIT_CODE);
                }
                cmdFail = false;
            } catch (ParseException exp) {
                cmdFail = true;
            }
        } // END optionsSVG

        // optionsSVGscope
        if(cmdFail) {
            try {
                CommandLine cmd = parser.parse(optionsSVGscope, args);
                System.out.print("stepmod2mn ");
                printVersion(cmd.hasOption("version"));
                
                List<String> arglist = cmd.getArgList();
                
                String argPathIn = arglist.get(0);
                
                if (!Files.exists(Paths.get(argPathIn))) {                   
                    System.out.println(String.format(INPUT_PATH_NOT_FOUND, XML_INPUT, argPathIn));
                    System.exit(Constants.ERROR_EXIT_CODE);
                }

                try {
                    stepmod2mn app = new stepmod2mn();
                    app.generateSVG(argPathIn, null, cmd.getOptionValue("output"),false);
                    System.out.println("End!");

                } catch (Exception e) {
                    e.printStackTrace(System.err);
                    System.exit(Constants.ERROR_EXIT_CODE);
                }
                cmdFail = false;
                
            } catch (ParseException exp) {
                cmdFail = true;
            }
        } // END optionsSVGscope

        // options
        if(cmdFail) {            
            try {             
                CommandLine cmd = parser.parse(options, args);
                
                System.out.print("stepmod2mn ");
                printVersion(cmd.hasOption("version"));
                
                List<String> arglist = cmd.getArgList();
                if (arglist.isEmpty() || arglist.get(0).trim().length() == 0) {
                    throw new ParseException("");
                }
                
                String argXMLin = arglist.get(0);
                
                String resourcePath = "";

                String argOutputPath = "";
                if (cmd.hasOption("output")) {
                    argOutputPath = cmd.getOptionValue("output");
                    String outPath_normalized = argOutputPath;
                    if (outPath_normalized.startsWith("./") || outPath_normalized.startsWith(".\\")) {
                        outPath_normalized = outPath_normalized.substring(2);
                    }
                    File fXMLout = new File(outPath_normalized);
                    argOutputPath = fXMLout.getAbsoluteFile().toString();
                    //new File(fXMLout.getParent()).mkdirs();
                }

                String boilerplatePath = "";
                if (cmd.hasOption("boilerplatepath")) {
                    boilerplatePath = cmd.getOptionValue("boilerplatepath") + File.separator;
                }

                String inputFolder = "";

                List<Map.Entry<String,String>> inputOutputFiles = new ArrayList<>();

                // if remote file (http or https)
                if (Util.isUrl(argXMLin)) {

                    if (!Util.isUrlExists(argXMLin)) {
                        System.out.println(String.format(INPUT_NOT_FOUND, XML_INPUT, argXMLin));
                        System.exit(Constants.ERROR_EXIT_CODE);
                    }

                    if (argOutputPath.isEmpty()) {
                        // if the parameter '--output' is missing,
                        // then save resulted adoc in the current folder (program dir)
                        argOutputPath = Paths.get(System.getProperty("user.dir"), Util.getFilenameFromURL(argXMLin)).toString();
                        argOutputPath = argOutputPath.substring(0, argOutputPath.lastIndexOf('.') + 1);
                        argOutputPath = argOutputPath + Constants.FORMAT;
                    }

                    inputOutputFiles.add(new AbstractMap.SimpleEntry<>(argXMLin, argOutputPath));

                    /*
                    //download to temp folder
                    //System.out.println("Downloading " + argXMLin + "...");
                    String urlFilename = new File(url.getFile()).getName();                    
                    InputStream in = url.openStream();                    
                    Path localPath = Paths.get(tmpfilepath.toString(), urlFilename);
                    Files.createDirectories(tmpfilepath);
                    Files.copy(in, localPath, StandardCopyOption.REPLACE_EXISTING);
                    //argXMLin = localPath.toString();
                    System.out.println("Done!");*/

                } else { // in case of local file
                    String argXMLin_normalized = argXMLin;
                    if (argXMLin_normalized.startsWith("./") || argXMLin_normalized.startsWith(".\\")) {
                        argXMLin_normalized = argXMLin_normalized.substring(2);
                    }
                    File fXMLin = new File(argXMLin_normalized);
                    fXMLin = fXMLin.getAbsoluteFile();
                    //System.out.println("fXMLin=" + fXMLin.toString());
                    if (!fXMLin.exists()) {
                        System.out.println(String.format(INPUT_NOT_FOUND, XML_INPUT, fXMLin));
                        System.exit(Constants.ERROR_EXIT_CODE);
                    }

                    /*if (argOutputPath.isEmpty()) { // is --output is empty, then save result in input folder
                        //outFileName = fXMLin.getAbsolutePath();
                        Path outPath = Paths.get(fXMLin.getParent(), Constants.DOCUMENT_ADOC);
                        argOutputPath = outPath.toString();
                    }*/

                    // if input path in the directory
                    if (fXMLin.isDirectory()) {
                        inputFolder = fXMLin.getAbsolutePath();

                        try (Stream<Path> walk = Files.walk(Paths.get(fXMLin.getAbsolutePath()))) {
                            List<String> inputXMLfiles = walk.map(x -> x.toString())
                                    .filter(f -> f.endsWith("resource.xml") || f.endsWith("module.xml")).collect(Collectors.toList());

                            for (String inputXmlFile: inputXMLfiles) {
                                String outAdocFile = XMLUtils.getOutputAdocPath(argOutputPath, inputXmlFile);
                                inputOutputFiles.add(new AbstractMap.SimpleEntry<>(inputXmlFile, outAdocFile));
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                        // if input is Publication Index XML file
                    } else if (argXMLin_normalized.toLowerCase().endsWith("publication_index.xml")) {
                        try {
                            File fpublication_index = new File(argXMLin_normalized);
                            File rootFolder = fpublication_index.getParentFile().getParentFile().getParentFile().getParentFile();
                            // inputFolder is root of repository
                            inputFolder = rootFolder.getAbsolutePath();

                            PublicationIndex publicationIndex = new PublicationIndex(argXMLin_normalized);
                            String documentType = "";
                            if (cmd.hasOption("type")) {
                                documentType = cmd.getOptionValue("type");
                            }
                            List<String> documentsPaths = publicationIndex.getDocumentsPaths(documentType);

                            Path dataPath = Paths.get(rootFolder.getAbsolutePath(),"data");

                            for (String documentFilename: documentsPaths) {
                                Path inputXmlFilePath = Paths.get(dataPath.toString(), documentFilename);
                                String outAdocFile = XMLUtils.getOutputAdocPath(argOutputPath, inputXmlFilePath.toString());
                                inputOutputFiles.add(new AbstractMap.SimpleEntry<>(inputXmlFilePath.toString(), outAdocFile));
                            }

                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                    else { // if input is concrete XML file
                        String outAdocFile = "";
                        if (argOutputPath.toLowerCase().endsWith(".adoc")) {
                            outAdocFile = argOutputPath;
                        } else {
                            outAdocFile = XMLUtils.getOutputAdocPath(argOutputPath, argXMLin.toString());
                        }

                        inputOutputFiles.add(new AbstractMap.SimpleEntry<>(argXMLin, outAdocFile));
                    }
                }

                try {
                    for (Map.Entry<String,String> entry: inputOutputFiles) {
                        String filenameIn = entry.getKey();
                        String filenameOut = entry.getValue();
                        File fileIn = new File(filenameIn);
                        File fileOut = new File(filenameOut);
                        stepmod2mn app = new stepmod2mn();
                        System.out.println(String.format(INPUT_LOG, XML_INPUT, filenameIn));
                        System.out.println(String.format(OUTPUT_LOG, Constants.FORMAT.toUpperCase(), filenameOut));
                        System.out.println();
                        app.setBoilerplatePath(boilerplatePath);
                        if (Util.isUrl(filenameIn)) {
                            resourcePath = Util.getParentUrl(filenameIn);
                        } else {
                            //parent path for input resource.xml
                            resourcePath = fileIn.getParent() + File.separator;
                        }
                        app.setResourcePath(resourcePath);
                        app.convertstepmod2mn(filenameIn, fileOut);
                    }

                    //if (isInputFolder) {
                    // Generate metanorma.yml in the root of path
                    //new MetanormaCollection(inputOutputFiles).generate(inputFolder);
                    String metanormaCollectionPath = argOutputPath;
                    if (metanormaCollectionPath == null || metanormaCollectionPath.isEmpty()) {
                        metanormaCollectionPath = inputFolder;
                    }
                    new MetanormaCollection(inputOutputFiles).generate(metanormaCollectionPath);
                    //}

                    System.out.println("End!");

                } catch (Exception e) {
                    e.printStackTrace(System.err);
                    System.exit(Constants.ERROR_EXIT_CODE);
                }
                cmdFail = false;
            } catch (ParseException exp) {
                cmdFail = true;            
            }
        } // END options
        
        // flush temporary folder
        if (!DEBUG) {
            Util.FlushTempFolder(tmpfilepath);
        }
        
        if (cmdFail) {
            System.out.println(USAGE);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
    }

    //private void convertstepmod2mn(File fXMLin, File fileOut) throws IOException, TransformerException, SAXParseException {
    private void convertstepmod2mn(String xmlFilePath, File fileOut) throws IOException, TransformerException, SAXParseException {
        System.out.println("Transforming...");
        try {
            Source srcXSL = null;
            
            String bibdataFileName = fileOut.getName();
            
            // get linearized XML with default attributes substitution from DTD
            String linearizedXML = XMLUtils.processLinearizedXML(xmlFilePath);
            
            // load linearized xml
            Source src = new StreamSource(new StringReader(linearizedXML));
            ClassLoader cl = this.getClass().getClassLoader();

            String xslKind = "resource";

            String rootElement = XMLUtils.getRootElement(linearizedXML);
            switch (rootElement) {
                case "resource":
                case "module":
                    xslKind = rootElement;
                    break;
            }

            String systemID = "stepmod2mn." + xslKind + ".adoc.xsl";

            //InputStream in = cl.getResourceAsStream(systemID);
            URL url = cl.getResource(systemID);
            
            srcXSL = new StreamSource(Util.getStreamFromResources(getClass().getClassLoader(), systemID));//"stepmod2mn.adoc.xsl"
            srcXSL.setSystemId(url.toExternalForm());
            
            TransformerFactory factory = TransformerFactory.newInstance();
            factory.setURIResolver(new ClasspathResourceURIResolver());            
            Transformer transformer = factory.newTransformer();
            
            Templates cachedXSLT = factory.newTemplates(srcXSL);
            //transformer = factory.newTransformer(srcXSL);
            transformer = cachedXSLT.newTransformer();
            
            transformer.setParameter("docfile", bibdataFileName);
            transformer.setParameter("pathSeparator", File.separator);
            transformer.setParameter("path", resourcePath);
            String outputPath = fileOut.getParent();
            if (outputPath == null) {
                outputPath = System.getProperty("user.dir");
            }
            transformer.setParameter("outpath", outputPath);
            transformer.setParameter("boilerplate_path", boilerplatePath);

            transformer.setParameter("debug", DEBUG);

            StringWriter resultWriter = new StringWriter();
            StreamResult sr = new StreamResult(resultWriter);

            transformer.transform(src, sr);
            String adoc = resultWriter.toString();

            Util.writeStringToFile(adoc, fileOut);

        } catch (SAXParseException e) {            
            throw (e);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
    }


    private static String getUsage() {
        StringWriter stringWriter = new StringWriter();
        PrintWriter pw = new PrintWriter(stringWriter);
        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp(pw, 80, CMD, "", options, 0, 0, "");
        pw.write("\nOR\n\n");
        formatter.printHelp(pw, 80, CMD_SVGscope, "", optionsSVGscope, 0, 0, "");
        pw.write("\nOR\n\n");
        formatter.printHelp(pw, 80, CMD_SVG, "", optionsSVG, 0, 0, "");
        pw.flush();
        return stringWriter.toString();
    }

    private static void printVersion(boolean print) {
        if (print) {            
            System.out.println(VER);
        }
    }       

    public void setResourcePath(String resourcePath) {
        this.resourcePath = resourcePath;
    }
    
    public void setBoilerplatePath(String boilerplatePath) {
        this.boilerplatePath = boilerplatePath;
    }

    public void generateSVG(String xmlFilePath, String image, String outPath, boolean isSVGmap) throws IOException, TransformerException, SAXParseException {
        List<String> xmlFiles = new ArrayList<>();
        try (Stream<Path> walk = Files.walk(Paths.get(xmlFilePath))) {
            xmlFiles = walk
                .filter(p -> !Files.isDirectory(p))   
                .map(p -> p.toString())
                .filter(f -> f.toLowerCase().endsWith(XML_EXTENSION))
                .collect(Collectors.toList());
        } catch (Exception e)
        {
            System.out.println("Can't generate SVG file(s) for " + xmlFilePath + "...");
            e.printStackTrace();
        }
        for(String xmlFile: xmlFiles) {
            try
            {
                String content = new String(Files.readAllBytes(Paths.get(xmlFile)));
                if (content.contains("img.area"))  {
                    String folder = new File(xmlFile).getParent() + File.separator;
                    //String svgFilename = xmlFile.substring(0, xmlFile.length() - XML_EXTENSION.length()) + SVG_EXTENSION;
                    String svgFilename = Util.changeFileExtension(xmlFile, SVG_EXTENSION);
                    if (outPath != null && !outPath.isEmpty()) {
                        if (!(outPath.toLowerCase().endsWith(SVG_EXTENSION) || outPath.toLowerCase().endsWith(XML_EXTENSION))) { // if folder

                            String xmlFilename = Paths.get(xmlFile).getFileName().toString();
                            svgFilename = Util.changeFileExtension(xmlFilename,SVG_EXTENSION);

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
                    try ( 
                        BufferedWriter writer = Files.newBufferedWriter(Paths.get(svgFilename))) {
                            writer.write(xmlSVG);                    
                    }
                    System.out.println("SVG saved in " + svgFilename + ".");
                }
            } 
            catch (Exception e) 
            {
                e.printStackTrace();
            }
        }
        //xmlFiles.forEach(x -> System.out.println(x));
    }
}
