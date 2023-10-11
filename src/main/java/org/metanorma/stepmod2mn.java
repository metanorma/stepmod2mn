package org.metanorma;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import org.xml.sax.SAXParseException;


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

    static final String ERRORS_FATAL_LOG = "errors.fatal.log.txt";

    static final String SVG_EXTENSION = ".svg";

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

    String repositoryIndexPath = "";

    String outputPathSchemas = "";

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
                String outputPathSchemas = "";
                if (cmd.hasOption("output")) {
                    argOutputPath = cmd.getOptionValue("output");
                    String outPath_normalized = argOutputPath;
                    if (outPath_normalized.startsWith("./") || outPath_normalized.startsWith(".\\")) {
                        outPath_normalized = outPath_normalized.substring(2);
                    }
                    File fXMLout = new File(outPath_normalized);
                    argOutputPath = fXMLout.getAbsoluteFile().toString();
                    //new File(fXMLout.getParent()).mkdirs();

                    Path schemasPath = Paths.get(new File(argOutputPath).getParent(), "schemas");
                    // create 'schemas' folder at the same level as output folder (for instance 'documents')
                    outputPathSchemas = schemasPath.toString();
                    new File(outputPathSchemas).mkdirs();
                }

                String boilerplatePath = "";
                if (cmd.hasOption("boilerplatepath")) {
                    boilerplatePath = cmd.getOptionValue("boilerplatepath") + File.separator;
                }

                String inputFolder = "";

                List<Map.Entry<String,String>> inputOutputFiles = new ArrayList<>();

                boolean isStandaloneXML = false;
                String repositoryIndexPath = "";
                // if remote file (http or https)
                if (Util.isUrl(argXMLin)) {

                    if (!Util.isUrlExists(argXMLin)) {
                        System.err.println(String.format(INPUT_NOT_FOUND, XML_INPUT, argXMLin));
                        System.exit(Constants.ERROR_EXIT_CODE);
                    }

                    if (argOutputPath.isEmpty()) {
                        // if the parameter '--output' is missing,
                        // then save resulted adoc in the current folder (program dir)
                        argOutputPath = Paths.get(System.getProperty("user.dir"), Util.getFilenameFromURL(argXMLin)).toString();
                        argOutputPath = argOutputPath.substring(0, argOutputPath.lastIndexOf('.') + 1);
                        argOutputPath = argOutputPath + Constants.FORMAT;
                    }

                    isStandaloneXML = true;
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
                        System.err.println(String.format(INPUT_NOT_FOUND, XML_INPUT, fXMLin));
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

                        RepositoryIndex repositoryIndex = new RepositoryIndex(inputFolder);
                        repositoryIndexPath = repositoryIndex.getPath();

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

                            RepositoryIndex repositoryIndex = new RepositoryIndex(argXMLin_normalized);
                            repositoryIndexPath = repositoryIndex.getPath();

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
                        isStandaloneXML = true;
                        String outAdocFile = "";
                        if (argOutputPath.toLowerCase().endsWith(".adoc")) {
                            outAdocFile = argOutputPath;
                        } else {
                            outAdocFile = XMLUtils.getOutputAdocPath(argOutputPath, argXMLin.toString());
                        }

                        RepositoryIndex repositoryIndex = new RepositoryIndex(argXMLin);
                        repositoryIndexPath = repositoryIndex.getPath();

                        inputOutputFiles.add(new AbstractMap.SimpleEntry<>(argXMLin, outAdocFile));
                    }
                }

                try {

                    List<Map.Entry<String,String>> badInputOutputFiles = new ArrayList<>();

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
                        app.setRepositoryIndexPath(repositoryIndexPath);
                        app.setOutputPathSchemas(outputPathSchemas);
                        boolean res = app.convertstepmod2mn(filenameIn, fileOut);
                        if (!res) {
                            badInputOutputFiles.add(entry);
                        }
                    }

                    inputOutputFiles.removeAll(badInputOutputFiles);

                    //if (isInputFolder) {
                    // Generate metanorma.yml in the root of path
                    //new MetanormaCollection(inputOutputFiles).generate(inputFolder);
                    String metanormaCollectionPath = argOutputPath;
                    if (isStandaloneXML) {
                        metanormaCollectionPath = new File(metanormaCollectionPath).getParent();
                    }
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
    private boolean convertstepmod2mn(String xmlFilePath, File fileOut) throws IOException, TransformerException, SAXParseException {
        System.out.println("Transforming...");
        try {
            Source srcXSL = null;
            
            String bibdataFileName = fileOut.getName();
            
            // get linearized XML with default attributes substitution from DTD
            String linearizedXML = XMLUtils.processLinearizedXML(xmlFilePath);

            // Issue: https://github.com/metanorma/stepmod2mn/issues/75
            // check @part
            String part = XMLUtils.getTextByXPath(linearizedXML, "*/@part");
            if (part.isEmpty() || !Util.isNumeric(part)) {
                System.err.println("Ignore document processing due the wrong attribute 'part' value: '" + part + "'");
                return false;
            }

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

            Path pathFileErrorsFatalLog = Paths.get(outputPath, ERRORS_FATAL_LOG);
            File fileErrorsFatalLog = new File(pathFileErrorsFatalLog.toString());
            if (fileErrorsFatalLog.exists()) {
                Files.delete(pathFileErrorsFatalLog);
            }

            transformer.setParameter("outpath", outputPath);
            transformer.setParameter("outpath_schemas", outputPathSchemas);
            transformer.setParameter("boilerplate_path", boilerplatePath);
            transformer.setParameter("repositoryIndex_path", repositoryIndexPath);
            transformer.setParameter("errors_fatal_log", ERRORS_FATAL_LOG);

            transformer.setParameter("debug", DEBUG);

            StringWriter resultWriter = new StringWriter();
            StreamResult sr = new StreamResult(resultWriter);

            transformer.transform(src, sr);
            String adoc = resultWriter.toString();

            Util.writeStringToFile(adoc, fileOut);

            if (fileErrorsFatalLog.length() != 0) {
                // delete current file from list
            } else {
                // delete empty
                if (Files.exists(fileErrorsFatalLog.toPath())) {
                    Files.delete(pathFileErrorsFatalLog);
                }
            }

        } catch (SAXParseException e) {            
            throw (e);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
        return true;
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

    public void setOutputPathSchemas(String outputPathSchemas) {
        this.outputPathSchemas = outputPathSchemas;
    }

    public void setBoilerplatePath(String boilerplatePath) {
        this.boilerplatePath = boilerplatePath;
    }

    public void setRepositoryIndexPath(String repositoryIndexPath) {
        this.repositoryIndexPath = repositoryIndexPath;
    }

    public void generateSVG(String xmlFilePath, String image, String outPath, boolean isSVGmap) throws IOException, TransformerException, SAXParseException {
        List<String> xmlFiles = new ArrayList<>();
        try (Stream<Path> walk = Files.walk(Paths.get(xmlFilePath))) {
            xmlFiles = walk
                .filter(p -> !Files.isDirectory(p))   
                .map(p -> p.toString())
                .filter(f -> f.toLowerCase().endsWith(Constants.XML_EXTENSION))
                .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Can't generate SVG file(s) for " + xmlFilePath + "...");
            e.printStackTrace();
        }
        for(String xmlFile: xmlFiles) {
            new SVGGenerator().generateSVG(xmlFile, image, outPath, isSVGmap);
        }
        //xmlFiles.forEach(x -> System.out.println(x));
    }
}
