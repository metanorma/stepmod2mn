package org.metanorma;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.FileSystemException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.Enumeration;
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
                System.out.println("Cannot get resource \"" + fileName + "\" from Jar file.");
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
            System.out.println("Cannot create the symbolic link \"" + symbolicLink + "\" for the file " + targetFilename + ".");
            if (ex instanceof FileSystemException) {
                System.out.println(((FileSystemException) ex).getReason());
            }
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
}
