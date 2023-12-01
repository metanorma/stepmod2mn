package org.metanorma;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.*;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Scanner;
import java.util.jar.Attributes;
import java.util.jar.Manifest;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 *
 * @author Alexander Dyuzhev
 */
public class Util {
   
    public static String getAppVersion() {
        String version = "";
        try {
            Enumeration<URL> resources = stepmod2mn.class.getClassLoader().getResources("META-INF/MANIFEST.MF");
            while (resources.hasMoreElements()) {
                Manifest manifest = new Manifest(resources.nextElement().openStream());
                // check that this is your manifest and do what you need or get the next one
                Attributes attr = manifest.getMainAttributes();
                String mainClass = attr.getValue("Main-Class");
                if(mainClass != null && mainClass.contains("org.metanorma.stepmod2mn")) {
                    version = manifest.getMainAttributes().getValue("Implementation-Version");
                }
            }
        } catch (IOException ex)  {
            version = "";
        }
        
        return version;
    }
 
    // get file from classpath, resources folder
    public static InputStream getStreamFromResources(ClassLoader classLoader, String fileName) throws Exception {        
        InputStream stream = classLoader.getResourceAsStream(fileName);
        if (stream == null) {
            throw new Exception("Cannot get resource \"" + fileName + "\" from Jar file.");
        }
        return stream;
    }

    public static String getFileContentFromResources(String fileName) throws Exception {
        ClassLoader classLoader = ClassLoader.getSystemClassLoader();
        try (InputStream is = classLoader.getResourceAsStream(fileName)) {
            if (is == null) {
                System.err.println("Cannot get resource \"" + fileName + "\" from Jar file.");
                return null;
            }
            try (InputStreamReader isr = new InputStreamReader(is);
                 BufferedReader reader = new BufferedReader(isr)) {
                return reader.lines().collect(Collectors.joining("\n"));
            }
        }
    }

    public static void createSymbolicLink(String targetFilename, String symbolicLink) {
        Path target = Paths.get(targetFilename);
        Path link = Paths.get(symbolicLink);
        try {
            if (Files.exists(link)) {
                Files.delete(link);
            }
            Files.createSymbolicLink(link, target);
        } catch (IOException ex) {
            String os = System.getProperty("os.name");
            if (os.toLowerCase().contains("windows")) {
                // need admin right to create symbolic link,
                // therefore create 'kunction' (mklink /J ...)
                // found here: https://github.com/Atry/scala-junction
                try {
                    Path targetRealPath = target.toRealPath();
                    com.dongxiguo.junction.Junction.createJunction(new File(link.toString()), new File(targetRealPath.toString()));
                } catch (Exception e) {
                    e.printStackTrace();;
                }
            } else {

                System.err.println("Cannot create the symbolic link \"" + symbolicLink + "\" for the file " + targetFilename + ".");
                if (ex instanceof FileSystemException) {
                    System.err.println(((FileSystemException) ex).getReason());
                }
            }
        }
    }

    public static void copyFile(String sourceFilename, String targetFilename) {
        try {
            Path source = Paths.get(sourceFilename);
            Path target = Paths.get(targetFilename);
            Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ex) {
            System.err.println("Cannot copy the file \"" + sourceFilename + "\" to the file " + targetFilename + ": " + ex);
        }
    }

    public static void copyFileFromResource(String sourceFilename, String targetFilename) {
        try {
            InputStream stream = getStreamFromResources(stepmod2mn.class.getClassLoader(), sourceFilename);
            if(stream == null) {
                System.err.println("Cannot get resource \"" + sourceFilename + "\" from Jar file.");
            }
            Path target = Paths.get(targetFilename);
            Files.copy(stream, target, StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception ex) {
            System.err.println("Cannot copy the resource file \"" + sourceFilename + "\" to the file " + targetFilename + ": " + ex);
        }
    }

    public static void FlushTempFolder(Path tmpfilepath) {
        if (Files.exists(tmpfilepath)) {
            //Files.deleteIfExists(tmpfilepath);
            try {
                Files.walk(tmpfilepath)
                    .sorted(Comparator.reverseOrder())
                        .map(Path::toFile)
                            .forEach(File::delete);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
    
    public static String getJavaTempDir() {
        return System.getProperty("java.io.tmpdir");
    }    
    
    
    public void callRuby() {
        StringBuilder sb = new StringBuilder();
        try {
            Process process = Runtime.getRuntime().exec("ruby script.rb");
            process.waitFor();

            BufferedReader processIn = new BufferedReader(
                    new InputStreamReader(process.getInputStream()));

            String line;
            while ((line = processIn.readLine()) != null) {
                //System.out.println(line);
                sb.append(line);
            } 
            
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    public static boolean isUrl(String urlname) {
        return urlname.toLowerCase().startsWith("http") || urlname.toLowerCase().startsWith("www.");
    }

    public static boolean isUrlExists(String urlname){
        try {
            HttpURLConnection.setFollowRedirects(false);        
            HttpURLConnection con = (HttpURLConnection) new URL(urlname).openConnection();
            con.setRequestMethod("HEAD");
            return (con.getResponseCode() == HttpURLConnection.HTTP_OK ||
                    con.getResponseCode() == HttpURLConnection.HTTP_MOVED_TEMP);
        }
        catch (Exception e) {
           e.printStackTrace();
           return false;
        }
    }
    
    public static String getParentUrl(String url) {
        String parentUrl;
        try {
            URI uri = new URI(url);
            URI parent = uri.getPath().endsWith("/") ? uri.resolve("..") : uri.resolve(".");
            return parent.toString();
        } catch (URISyntaxException ex) {
            return "";
        }
    }
    
    public static String getFilenameFromURL(String url) {
        String fileName = url.substring(url.lastIndexOf('/') + 1, url.length());
        return fileName;
    }
    
    public static long getFileSize(File file) {
        long length = file.length();
        return length;
    }
    
    public static String getFileContent(String filepath) {
        String fileContent = "";
        try {
            if (filepath.toLowerCase().startsWith("http") || filepath.toLowerCase().startsWith("www.")) { 
                URL url = new URL(filepath);
                ByteArrayOutputStream output = new ByteArrayOutputStream();
                try (InputStream inputStream = url.openStream()) {
                    int n = 0;
                    byte [] buffer = new byte[1024];
                    while (-1 != (n = inputStream.read(buffer))) {
                        output.write(buffer, 0, n);
                    }
                }
                byte[] bytes = output.toByteArray();
                fileContent = new String(bytes);
            } else {
                Path filePath = Paths.get(filepath);
                byte[] bytes = Files.readAllBytes(filePath);
                fileContent = new String(bytes);
            }
        } catch (Exception ex) {
            return "Can't read a file " + filepath + ":" + ex.toString();
        }
        return fileContent;
    }

    public static String changeFileExtension(String filename, String extension) {
        int startPosExtension = filename.lastIndexOf(".");
        if (startPosExtension != -1) {
            String currentExtension = filename.substring(startPosExtension);
            return filename.substring(0, filename.length() - currentExtension.length()) + extension;
        }
        return filename.concat(extension);
    }

    public static void writeStringToFile(String adoc, File fileOut) throws IOException {
        try (Scanner scanner = new Scanner(adoc)) {
            String outputFile = fileOut.getAbsolutePath();
            StringBuilder sbBuffer = new StringBuilder();
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                sbBuffer.append(line);
                sbBuffer.append(System.getProperty("line.separator"));
            }
            writeBuffer(sbBuffer, outputFile);
        }
        System.out.println("Saved (" + fileOut.getName() + ") " + Util.getFileSize(fileOut) + " bytes.");
    }

    private static void writeBuffer(StringBuilder sbBuffer, String outputFile) throws IOException {
        try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outputFile))) {
            writer.write(sbBuffer.toString());
        }
        sbBuffer.setLength(0);
    }

    public static String getRelativePath(String filePath, String outputPath) {
        Path fullPath = Paths.get(filePath);
        try {
            fullPath = fullPath.toRealPath();
        } catch (java.nio.file.NoSuchFileException e) {
          // to prevent exception for non-existing .exp (generates by stepmod-utils)
        } catch (IOException e) {
            e.printStackTrace();;
        }
        Path relativePath = Paths.get(outputPath).relativize(fullPath);
        String strRelativePath = relativePath.toString().replace("\\","/");
        return strRelativePath;
    }

    public static boolean isNumeric(String strNum) {
        if (strNum == null) {
            return false;
        }
        try {
            int d = Integer.parseInt(strNum);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }

    public static boolean fileExists(String filename) {
        Path path = Paths.get(filename);
        return Files.exists(path);
    }

    public static String getRepositoryRootFolder(String startFolder) {
        // find repository_index.xml
        RepositoryIndex repositoryIndex = new RepositoryIndex(startFolder, false);
        String repositoryIndexPath = repositoryIndex.getPath();
        if (!repositoryIndexPath.isEmpty()) {
            return new File(repositoryIndexPath).getParent();
        } else {
            // if repository_index.xml isn't found, then find folder that
            // contains data/resource_docs

            boolean endFoldersTree = false;

            Path repositoryRootPath = Paths.get(startFolder, "data","resource_docs");

            while (!Files.exists(repositoryRootPath) && !endFoldersTree) {
                try {
                    startFolder = Paths.get(startFolder).getParent().toString();
                    repositoryRootPath = Paths.get(startFolder,"data","resource_docs");
                } catch (Exception ex) {
                    //System.err.println("Can't find the repository root folder.");
                    endFoldersTree = true;
                }
            }
            if (endFoldersTree) {
                return "";
            } else {
                return repositoryRootPath.toString();
            }
        }

    }
}
