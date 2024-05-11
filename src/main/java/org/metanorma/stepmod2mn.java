package org.metanorma;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
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

    static final String CMD = "java -Xss5m -jar stepmod2mn.jar <resource or module or publication index xml file> [options -o, -od, -os -v, -b <path> -t <type> -e <documents list> -inc <documents list>]";
    static final String CMD_SVGscope1 = "java -jar stepmod2mn.jar <start folder to process xml maps files> --svg";
    static final String CMD_SVGscope2 = "java -jar stepmod2mn.jar <start folder to process xml maps files> --output-documents --output-schemas --svg";
    static final String CMD_SVG = "java -jar stepmod2mn.jar --xml <Express Imagemap XML file path> --image <Image file name> [--svg <resulted SVG map file or folder>] [-v]";
    
    static final String INPUT_NOT_FOUND = "Error: %s file '%s' not found!";    
    static final String INPUT_PATH_NOT_FOUND = "Error: %s path '%s' not found!";    
    static final String XML_INPUT = "XML";    
    static final String INPUT_LOG = "Input: %s (%s)";    
    static final String OUTPUT_LOG = "Output: %s (%s)";

    static final String ERRORS_FATAL_LOG = "errors.fatal.log.txt";

    static final String SVG_EXTENSION = ".svg";

    static final String XML_RESOURCE = "resource.xml";
    static final String XML_MODULE = "module.xml";

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
    
    static final Options optionsSVGscope1 = new Options() {
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
        }
    };

    static final Options optionsSVGscope2 = new Options() {
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
            addOption(Option.builder("od")
                    .longOpt("output-documents")
                    .desc("output directory for documents's SVG")
                    .hasArg()
                    .required(true)
                    .build());
            addOption(Option.builder("os")
                    .longOpt("output-schemas")
                    .desc("output directory for schemas's SVG")
                    .hasArg()
                    .required(true)
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
            addOption(Option.builder("od")
                    .longOpt("output-documents")
                    .desc("output directory for documents")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("os")
                    .longOpt("output-schemas")
                    .desc("output directory for schemas")
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
            addOption(Option.builder("e")
                    .longOpt("exclude")
                    .desc("exclude specified documents (list in the quotes, spaces separated)")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("in")
                    .longOpt("input-documents")
                    .desc("folder with adoc documents (for publication index only)")
                    .hasArg()
                    .required(false)
                    .build());
            addOption(Option.builder("inc")
                    .longOpt("include-only")
                    .desc("process specified documents only (list in the quotes, spaces separated)")
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

    RepositoryIndex repositoryIndex = null;

    String outputPathSchemas = "";

    List<String> excludeList = new ArrayList<>();
    List<String> includeOnlyList = new ArrayList<>();

    boolean isPublicationIndexMode = false;
    boolean isDocumentsGenerationMode = false;

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
        }

        // optionsSVG
        if(cmdFail) {
            try {
                runOptionsSVG(args);
                cmdFail = false;
            } catch (ParseException exp) {
                cmdFail = true;
            }
        }

        // optionsSVGscope1
        if(cmdFail) {
            try {
                runoptionsSVGscope1(args);
                cmdFail = false;
            } catch (ParseException exp) {
                cmdFail = true;
            }
        }

        // optionsSVGscope2
        if(cmdFail) {
            try {
                runoptionsSVGscope2(args);
                cmdFail = false;
            } catch (ParseException exp) {
                cmdFail = true;
            }
        }

        // options
        if(cmdFail) {            
            try {
                runoptions(args);

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

    private static void runOptionsSVG(String[] args) throws ParseException {
        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(optionsSVG, args);
        System.out.print("stepmod2mn ");
        printVersion(cmd.hasOption("version"));

        String xmlIn = cmd.getOptionValue("xml");
        String imageIn = cmd.getOptionValue("image");
        //get filename from path
        imageIn = Paths.get(imageIn).getFileName().toString();

        try {
            stepmod2mn app = new stepmod2mn();
            app.generateSVGs(xmlIn, imageIn, cmd.getOptionValue("svg"), null, false);
            System.out.println("End!");

        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
    }

    private static void runoptionsSVGscope1(String[] args) throws ParseException {
        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(optionsSVGscope1, args);
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
            app.generateSVGs(argPathIn, null, null, null,false);
            System.out.println("End!");
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
    }

    private static void runoptionsSVGscope2(String[] args) throws ParseException {
        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(optionsSVGscope2, args);
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
            app.generateSVGs(argPathIn, null, cmd.getOptionValue("output-documents"), cmd.getOptionValue("output-schemas"), false);
            System.out.println("End!");

        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
    }

    private static void runoptions(String[] args) throws ParseException {
        CommandLineParser parser = new DefaultParser();
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
        }
        if (cmd.hasOption("output-documents")) {
            argOutputPath = cmd.getOptionValue("output-documents");
        }
        if (!argOutputPath.isEmpty()) {
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
        }

        if (cmd.hasOption("output-schemas")) {
            outputPathSchemas = cmd.getOptionValue("output-schemas");
            String outputPathSchemas_normalized = outputPathSchemas;
            if (outputPathSchemas_normalized.startsWith("./") || outputPathSchemas_normalized.startsWith(".\\")) {
                outputPathSchemas_normalized = outputPathSchemas_normalized.substring(2);
            }
            File fXMLout = new File(outputPathSchemas_normalized);
            outputPathSchemas = fXMLout.getAbsoluteFile().toString();
        }
        if (!outputPathSchemas.isEmpty()) {
            new File(outputPathSchemas).mkdirs();
        }

        String boilerplatePath = "";
        if (cmd.hasOption("boilerplatepath")) {
            boilerplatePath = cmd.getOptionValue("boilerplatepath") + File.separator;
        }

        List<String> excludeList = new ArrayList<>();
        if (cmd.hasOption("exclude")) {
            excludeList = Arrays.asList(cmd.getOptionValue("exclude").split(" "));
        }

        List<String> includeOnlyList = new ArrayList<>();
        if (cmd.hasOption("include-only")) {
            includeOnlyList = Arrays.asList(cmd.getOptionValue("include-only").split(" "));
        }

        String inputDocumentsFolder = "";
        if (cmd.hasOption("input-documents")) {
            inputDocumentsFolder = cmd.getOptionValue("input-documents");
        }

        String inputFolder = "";

        List<Map.Entry<String,String>> inputOutputFiles = new ArrayList<>();

        boolean isStandaloneXML = false;
        RepositoryIndex repositoryIndex = null;
        boolean isPublicationIndexMode = false;
        boolean isDocumentsGenerationMode = false;
        String namePublicationIndex = "";
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
                isDocumentsGenerationMode = true;

                inputFolder = fXMLin.getAbsolutePath();

                repositoryIndex = new RepositoryIndex(inputFolder);

                try (Stream<Path> walk = Files.walk(Paths.get(fXMLin.getAbsolutePath()))) {
                    List<String> inputXMLfiles = walk.map(x -> x.toString())
                            .filter(f -> f.endsWith("/" + XML_RESOURCE) ||
                                    f.endsWith("\\" + XML_RESOURCE) ||
                                    f.endsWith("/" + XML_MODULE) ||
                                    f.endsWith("\\" + XML_MODULE)).collect(Collectors.toList());

                    for (String inputXmlFile: inputXMLfiles) {
                        String outAdocFile = XMLUtils.getOutputAdocPath(argOutputPath, inputXmlFile, inputOutputFiles);
                        inputOutputFiles.add(new AbstractMap.SimpleEntry<>(inputXmlFile, outAdocFile));
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

                // if input is Publication Index XML file
            } else if (argXMLin_normalized.toLowerCase().endsWith("publication_index.xml")) {
                try {
                    isPublicationIndexMode = true;
                    File fpublication_index = new File(argXMLin_normalized);
                    namePublicationIndex = new File(argXMLin_normalized).getParentFile().getName();
                    File rootFolder = fpublication_index.getParentFile().getParentFile().getParentFile().getParentFile();
                    // inputFolder is root of repository
                    inputFolder = rootFolder.getAbsolutePath();

                    repositoryIndex = new RepositoryIndex(argXMLin_normalized);

                    PublicationIndex publicationIndex = new PublicationIndex(argXMLin_normalized);
                    String documentType = "";
                    if (cmd.hasOption("type")) {
                        documentType = cmd.getOptionValue("type");
                    }
                    List<String> documentsPaths = publicationIndex.getDocumentsPaths(documentType);

                    Path dataPath = Paths.get(rootFolder.getAbsolutePath(),"data");

                    for (String documentFilename: documentsPaths) {
                        Path inputXmlFilePath = Paths.get(dataPath.toString(), documentFilename);
                        String adocFolder = argOutputPath;
                        if (inputDocumentsFolder.isEmpty()) {
                            adocFolder = Paths.get(argOutputPath, "documents").toString(); //default
                        } else {
                            adocFolder = inputDocumentsFolder;
                        }

                        String outAdocFile = XMLUtils.getOutputAdocPath(adocFolder, inputXmlFilePath.toString(), inputOutputFiles);
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

                repositoryIndex = new RepositoryIndex(argXMLin);

                inputOutputFiles.add(new AbstractMap.SimpleEntry<>(argXMLin, outAdocFile));
            }
        }

        try {

            List<Map.Entry<String,String>> badInputOutputFiles = new ArrayList<>();
            List<Map.Entry<String,String>> withdrawnInputOutputFiles = new ArrayList<>();
            List<Map.Entry<String,String>> missingInputOutputFiles = new ArrayList<>();
            List<Map.Entry<String,String>> wrongPartInputOutputFiles = new ArrayList<>();

            for (Map.Entry<String,String> entry: inputOutputFiles) {
                String filenameIn = entry.getKey();
                String filenameOut = entry.getValue();
                File fileIn = new File(filenameIn);
                File fileOut = new File(filenameOut);

                stepmod2mn app = new stepmod2mn();
                app.setBoilerplatePath(boilerplatePath);
                if (Util.isUrl(filenameIn)) {
                    resourcePath = Util.getParentUrl(filenameIn);
                } else {
                    //parent path for input resource.xml
                    resourcePath = fileIn.getParent() + File.separator;
                }
                app.setResourcePath(resourcePath);
                app.setRepositoryIndex(repositoryIndex);
                app.setPublicationIndexMode(isPublicationIndexMode);
                app.setDocumentsGenerationMode(isDocumentsGenerationMode);
                app.setOutputPathSchemas(outputPathSchemas);
                app.setExcludeList(excludeList);
                app.setIncludeOnlyList(includeOnlyList);
                //boolean res = app.convertstepmod2mn(filenameIn, fileOut);
                DocumentStatus documentStatus = app.convertstepmod2mn(filenameIn, fileOut);
                if (!(documentStatus == DocumentStatus.OK)) {
                    badInputOutputFiles.add(entry);
                    switch (documentStatus) {
                        case WITHDRAWN:
                            withdrawnInputOutputFiles.add(entry);
                            break;
                        case MISSING:
                            missingInputOutputFiles.add(entry);
                            break;
                        case WRONGPART:
                            wrongPartInputOutputFiles.add(entry);
                            break;
                    }
                }
            }

            if (!inputOutputFiles.isEmpty()) { // && isPublicationIndexMode

                inputOutputFiles.removeAll(badInputOutputFiles);

                // output folder for collection.yml
                String collectionOutputPath = argOutputPath;
                if (isStandaloneXML || isDocumentsGenerationMode) {
                    // get parent folder
                    collectionOutputPath = new File(argOutputPath).getParent();
                }
                if (collectionOutputPath == null || collectionOutputPath.isEmpty()) {
                    collectionOutputPath = inputFolder;
                }

                // output folder for metanorma.yml
                String metanormaCollectionPath = argOutputPath;
                if (isStandaloneXML || isDocumentsGenerationMode) {
                    // get parent folder
                    metanormaCollectionPath = new File(metanormaCollectionPath).getParent();
                }
                if (metanormaCollectionPath == null || metanormaCollectionPath.isEmpty()) {
                    metanormaCollectionPath = inputFolder;
                }

                // Generate collection.sh
                // commented, see https://github.com/metanorma/stepmod2mn/issues/124#issuecomment-1859657292
                // new ScriptCollection(argOutputPath, inputOutputFiles).generate();

                // Generate collection manifest collection.yml
                new MetanormaCollectionManifest(inputOutputFiles).generate(collectionOutputPath, namePublicationIndex, DocumentStatus.OK);

                // Generate cover.html
                // commented, see https://github.com/metanorma/stepmod2mn/issues/124#issuecomment-1859657292
                // new MetanormaCover(argOutputPath, inputOutputFiles).generate();

                // Generate metanorma.yml
                new MetanormaCollection(inputOutputFiles).generate(metanormaCollectionPath, namePublicationIndex, DocumentStatus.OK);

                // Generate collection.withdrawn.yml
                new MetanormaCollectionManifest(withdrawnInputOutputFiles).generate(collectionOutputPath, namePublicationIndex, DocumentStatus.WITHDRAWN);
                // Generate metanorma.withdrawn.yml
                new MetanormaCollection(withdrawnInputOutputFiles).generate(metanormaCollectionPath, namePublicationIndex, DocumentStatus.WITHDRAWN);

                // Generate collection.missing.yml
                new MetanormaCollectionManifest(missingInputOutputFiles).generate(collectionOutputPath, namePublicationIndex, DocumentStatus.MISSING);
                // Generate metanorma.missing.yml
                new MetanormaCollection(missingInputOutputFiles).generate(metanormaCollectionPath, namePublicationIndex, DocumentStatus.MISSING);

                // Generate collection.wrongpart.yml
                new MetanormaCollectionManifest(wrongPartInputOutputFiles).generate(collectionOutputPath, namePublicationIndex, DocumentStatus.WRONGPART);
                // Generate metanorma.wrongpart.yml
                new MetanormaCollection(wrongPartInputOutputFiles).generate(metanormaCollectionPath, namePublicationIndex, DocumentStatus.WRONGPART);

            }

            System.out.println("End!");

        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
    }

    //private void convertstepmod2mn(File fXMLin, File fileOut) throws IOException, TransformerException, SAXParseException {
    private DocumentStatus convertstepmod2mn(String xmlFilePath, File fileOut) throws IOException, TransformerException, SAXParseException {
        //boolean result = true;
        DocumentStatus result = DocumentStatus.OK;
        try {

            System.out.println(String.format(INPUT_LOG, XML_INPUT, xmlFilePath));

            Source srcXSL = null;

            String bibdataFileName = fileOut.getName();

            // get linearized XML with default attributes substitution from DTD
            String linearizedXML = XMLUtils.processLinearizedXML(xmlFilePath);

            // Issue: https://github.com/metanorma/stepmod2mn/issues/75
            // check @part
            String documentName = XMLUtils.getTextByXPath(linearizedXML, "*/@name");
            String part = XMLUtils.getTextByXPath(linearizedXML, "*/@part");
            String xslKind = "resource";
            String rootElement = XMLUtils.getRootElement(linearizedXML);
            switch (rootElement) {
                case "resource":
                case "module":
                    xslKind = rootElement;
                    break;
            }

            if (excludeList.contains(documentName)) {
                System.out.println("[WARNING] The document '" + documentName + "' excluded from the processing.");
                //return false;
                return DocumentStatus.EXCLUDED;
            }

            if (excludeList.contains(part)) {
                System.out.println("[WARNING] The document '" + documentName + "' (part '" + part + "') excluded from the processing.");
                //return false;
                return DocumentStatus.EXCLUDED;
            }

            if (!includeOnlyList.isEmpty() && !includeOnlyList.contains(documentName)) {
                System.out.println("[WARNING] The document '" + documentName + "' skipped from the processing.");
                //return false;
                return DocumentStatus.SKIPPED;
            }

            if (isPublicationIndexMode) {
                if (part.isEmpty() || !Util.isNumeric(part)) {
                    //System.err.println("[WARNING] Ignore document processing due the wrong attribute 'part' value: '" + part + "'");
                    System.out.println("[WARNING] The document '" + documentName + "' skipped in the metanorma collection due the wrong attribute 'part' value: '" + part + "'");
                    //result = false;
                    return DocumentStatus.WRONGPART;
                }
                if (!(repositoryIndex.contains(documentName, rootElement))) {
                    System.out.println("[WARNING] The document '" + documentName + "' skipped in the metanorma collection - it's missing in the repository index.");
                    //result = false;
                    return DocumentStatus.MISSING;
                }
                if (repositoryIndex.isWithdrawn(documentName, rootElement)) {
                    System.out.println("[WARNING] The document '" + documentName + "' skipped in the metanorma collection - it has status 'withdrawn' in the repository index.");
                    //result = false;
                    return DocumentStatus.WITHDRAWN;
                }
            }

            if (isDocumentsGenerationMode) {
                if (!(repositoryIndex.contains(documentName, rootElement))) {
                    System.out.println("[WARNING] The document '" + documentName + "' is missing in the repository index.");
                    //return false;
                    result = DocumentStatus.MISSING;
                }
                if (repositoryIndex.isWithdrawn(documentName, rootElement)) {
                    System.out.println("[WARNING] The document '" + documentName + "' has status 'withdrawn' in the repository index.");
                    //result = false;
                    result = DocumentStatus.WITHDRAWN;
                }
            }

            if (!isPublicationIndexMode) {

                System.out.println(String.format(OUTPUT_LOG, Constants.FORMAT.toUpperCase(), fileOut.toString()));
                System.out.println();

                System.out.println("Transforming...");

                // load linearized xml
                Source src = new StreamSource(new StringReader(linearizedXML));
                ClassLoader cl = this.getClass().getClassLoader();

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
                String outputPathSchemasKind = outputPathSchemas;
                if (outputPathSchemasKind != null && !outputPathSchemasKind.isEmpty()) {
                    outputPathSchemasKind = Paths.get(outputPathSchemasKind, rootElement + "s").toString();
                }
                transformer.setParameter("outpath_schemas", outputPathSchemasKind);
                transformer.setParameter("boilerplate_path", boilerplatePath);
                if (repositoryIndex != null) {
                    transformer.setParameter("repositoryIndex_path", repositoryIndex.getPath());
                }
                transformer.setParameter("errors_fatal_log", ERRORS_FATAL_LOG);

                transformer.setParameter("debug", DEBUG);

                if (!DEBUG) {
                    transformer.setErrorListener(new CustomErrorListener());
                }

                StringWriter resultWriter = new StringWriter();
                StreamResult sr = new StreamResult(resultWriter);

                transformer.transform(src, sr);
                String adoc = resultWriter.toString();

                Util.writeStringToFile(adoc, fileOut);

                if (fileErrorsFatalLog.length() != 0) {
                    // if current document doesn't exist in the repository index, then
                    // delete it from list
                    /*if(isPublicationIndexMode) {
                        result = false;
                    }*/
                } else {
                    // delete empty
                    if (Files.exists(fileErrorsFatalLog.toPath())) {
                        Files.delete(pathFileErrorsFatalLog);
                    }
                }
            }
        } catch (SAXParseException e) {            
            throw (e);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(Constants.ERROR_EXIT_CODE);
        }
        return result;
    }


    private static String getUsage() {
        StringWriter stringWriter = new StringWriter();
        PrintWriter pw = new PrintWriter(stringWriter);
        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp(pw, 80, CMD, "", options, 0, 0, "");
        pw.write("\nOR\n\n");
        formatter.printHelp(pw, 80, CMD_SVGscope1, "", optionsSVGscope1, 0, 0, "");
        pw.write("\nOR\n\n");
        formatter.printHelp(pw, 80, CMD_SVGscope2, "", optionsSVGscope2, 0, 0, "");
        pw.write("\nOR\n\n");
        formatter.printHelp(pw, 80, CMD_SVG, "", optionsSVG, 0, 0, "");
        pw.flush();
        return stringWriter.toString();
    }

    private static void printVersion(boolean print) {
        if (print) {            
            System.out.println(VER);
        } else {
            System.out.println("");
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

    public void setExcludeList(List<String> excludeList) {
        this.excludeList = excludeList;
    }

    public void setIncludeOnlyList(List<String> includeOnlyList) {
        this.includeOnlyList = includeOnlyList;
    }

    public void setRepositoryIndex(RepositoryIndex repositoryIndex) {
        this.repositoryIndex = repositoryIndex;
    }

    public void setPublicationIndexMode(boolean isPublicationIndexMode) {
        this.isPublicationIndexMode = isPublicationIndexMode;
    }

    public void setDocumentsGenerationMode(boolean isDocumentsGenerationMode) {
        this.isDocumentsGenerationMode = isDocumentsGenerationMode;
    }

    public String generateSVG(String xmlFilesPath, String image, String outPath, boolean isSVGmap) throws IOException, TransformerException, SAXParseException {
        List<String> xmlFiles = new ArrayList<>();
        try (Stream<Path> walk = Files.walk(Paths.get(xmlFilesPath))) {
            xmlFiles = walk
                    .filter(p -> !Files.isDirectory(p))
                    .map(p -> p.toString())
                    .filter(f -> f.toLowerCase().endsWith(Constants.XML_EXTENSION))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.print("[ERROR] Can't generate SVG file(s) for " + xmlFilesPath + "...");
            if (e instanceof NoSuchFileException || e instanceof FileNotFoundException) {
                System.err.println(" File not found.");
            } else {
                System.err.println("");
                e.printStackTrace();
            }
        }
        List<String> outputSVGs = new ArrayList<>();
        for(String xmlFile: xmlFiles) {
            outputSVGs.add(new SVGGenerator().generateSVG(xmlFile, image, outPath, isSVGmap));
        }
        return outputSVGs.toString()
                .replace("[", "")
                .replace("]", "")
                .replace(",", " ")
                .replace(" ", "");
    }

    public String generateSVGs(String xmlFilesPath, String image, String outPathDocument, String outPathSchemas, boolean isSVGmap) throws IOException, TransformerException, SAXParseException {

        List<String> xmlFiles = new ArrayList<>();
        System.out.println("[INFO] Finding *.xml files...");
        try (Stream<Path> walk = Files.walk(Paths.get(xmlFilesPath))) {
            xmlFiles = walk
                .filter(p -> !Files.isDirectory(p))   
                .map(p -> p.toString())
                .filter(f -> f.toLowerCase().endsWith(Constants.XML_EXTENSION))
                .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.print("[ERROR] Can't generate SVG file(s) for " + xmlFilesPath + "...");
            if (e instanceof NoSuchFileException || e instanceof FileNotFoundException) {
                System.err.println(" File not found.");
            } else {
                System.err.println("");
                e.printStackTrace();
            }
        }

        // list of the document's xml: resource.xml and module.xml
        System.out.print("[INFO] Finding images in the resource.xml and module.xml files...");
        List<String> xmlDocuments = xmlFiles.stream().filter(f -> f.endsWith("/" + XML_RESOURCE) ||
                f.endsWith("\\" + XML_RESOURCE) ||
                f.endsWith("/" + XML_MODULE) ||
                f.endsWith("\\" + XML_MODULE)).collect(Collectors.toList());

        // iteration of each document xml and collect img and imgfile values for schemas
        String xpathImages = "//schema/express-g/imgfile/@file | " +
                "//schema/express-g/img/@file | " +
                "//arm/express-g/img/@file | " +
                "//arm_lf/express-g/img/@file | " +
                "//arm/express-g/imgfile/@file | " +
                "//arm_lf/express-g/imgfile/@file | " +
                "//mim/express-g/img/@file | " +
                "//mim_lf/express-g/img/@file | " +
                "//mim/express-g/imgfile/@file | " +
                "//mim_lf/express-g/imgfile/@file";
        Map<String, String> imageVsSchemaType = new LinkedHashMap<>();
        for(String xmlDocument: xmlDocuments) {
            String linearizedXML = XMLUtils.processLinearizedXML(xmlDocument);
            String type = "resources";
            if (xmlDocument.endsWith("module.xml")) {
                type = "modules";
            }
            List<String> images = XMLUtils.getValuesByXPath(linearizedXML, xpathImages);
            for(String item: images) {
                /*if (imageVsSchemaType.get(item) != null && !imageVsSchemaType.get(item).equals(type)) {
                    System.out.println("Attention!");
                }
                if (imageVsSchemaType.containsKey(item) && imageVsSchemaType.containsValue(type) && !imageVsSchemaType.get(item).equals(type)) {
                    System.out.println("Attention!");
                }*/
                imageVsSchemaType.put(item, type);
            }
        }
        System.out.println(" " + imageVsSchemaType.size()  + " images found.");
        //System.out.println(imageVsSchemaType);

        List<String> outputSVGs = new ArrayList<>();
        for(String xmlFile: xmlFiles) {
            String outPath = outPathDocument;
            // determine: .svg relates to the document or schema
            if (outPathDocument != null && !outPathDocument.isEmpty() &&
                    outPathSchemas != null && !outPathSchemas.isEmpty()) {
                String filename = new File(xmlFile).getName();
                String parentFolder = new File(xmlFile).getParent();
                String parentFolderName = new File(xmlFile).getParentFile().getName();
                Path xmlDocumentPath = Paths.get(parentFolder, XML_RESOURCE);
                if (!xmlDocumentPath.toFile().exists()) {
                    xmlDocumentPath = Paths.get(parentFolder, XML_MODULE);
                }

                if (!xmlDocumentPath.toFile().exists()) {
                    xmlDocumentPath = null;
                    // the folder 'resource', or another non 'resource_docs' or modules folder
                    // then output to 'schemas' folder
                    String kind = imageVsSchemaType.get(filename);
                    if (kind == null) {
                        kind = "modules";
                    }
                    outPath = Paths.get(outPathSchemas, kind).toString();
                    isSVGmap = false;
                } else {

                    String xmlFilename = xmlDocumentPath.getFileName().toString();
                    String linearizedXML = XMLUtils.processLinearizedXML(xmlDocumentPath.toString());

                    String xpathImageSVG = "//imgfile[@file = '" + filename + "']/@file | " +
                            "//img[@file = '" + filename  + "']/@file";

                    // check existing of image reference
                    String attFile = XMLUtils.getTextByXPath(linearizedXML, xpathImageSVG);
                    if (!attFile.isEmpty()) {

                        boolean isSchemaSVG = false;
                        String xpathSchemaSVG = "//schema/express-g/imgfile[@file = '" + filename + "']/@file | " +
                                "//schema/express-g/img[@file = '" + filename + "']/@file | " +
                                "//arm/express-g/img[@file = '" + filename + "']/@file | " +
                                "//arm_lf/express-g/img[@file = '" + filename + "']/@file | " +
                                "//arm/express-g/imgfile[@file = '" + filename + "']/@file | " +
                                "//arm_lf/express-g/imgfile[@file = '" + filename + "']/@file | " +
                                "//mim/express-g/img[@file = '" + filename + "']/@file | " +
                                "//mim_lf/express-g/img[@file = '" + filename + "']/@file | " +
                                "//mim/express-g/imgfile[@file = '" + filename + "']/@file | " +
                                "//mim_lf/express-g/imgfile[@file = '" + filename + "']/@file";
                        attFile = XMLUtils.getTextByXPath(linearizedXML, xpathSchemaSVG);
                        isSchemaSVG = !attFile.isEmpty();

                        String attPart = XMLUtils.getTextByXPath(linearizedXML, "*/@part");

                        if (isSchemaSVG) {
                            isSVGmap = false;
                            String kind = imageVsSchemaType.get(filename);
                            if (kind == null) {
                                kind = "modules";
                            }
                            outPath = Paths.get(outPathSchemas, kind).toString();
                        } else {
                            if (attPart.isEmpty()) {
                                System.out.println("[ERROR] No part number. Skip '" + xmlFile +"' processing.");
                                xmlFile = null;
                            } else {
                                isSVGmap = true;
                                String folderDocumentName = "";
                                if (attPart.matches("^\\d+\\-\\d+$")) {
                                    folderDocumentName = "iso-" + attPart;
                                } else {
                                    folderDocumentName = Constants.ISO_STANDARD_PREFIX + attPart;
                                }
                                outPath = Paths.get(outPath, folderDocumentName).toString();
                            }
                        }
                    } else {
                        xmlFile = null;
                    }
                }
            }
            if (xmlFile != null) {
                outputSVGs.add(new SVGGenerator().generateSVG(xmlFile, image, outPath, isSVGmap));
            }
        }
        return outputSVGs.toString()
                .replace("[", "")
                .replace("]", "")
                .replace(",", " ")
                .replace(" ", "");
    }
}
