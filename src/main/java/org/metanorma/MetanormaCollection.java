package org.metanorma;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

public class MetanormaCollection {

    private final String TC = "TC 184";
    private final String SC = "SC 4";
    private final String WG = "WG 12";
    private final String ORGANIZATION = "\"ISO/" + TC + "/" + SC + "/" + WG + "\"";
    private final String NAME = "\"ISO 10303 in Metanorma\"";

    List<Map.Entry<String,String>> inputOutputFiles;
    public MetanormaCollection(List<Map.Entry<String,String>> inputOutputFiles) {
        this.inputOutputFiles = inputOutputFiles;
    }
    public void generate(String outputFolder, String namePublicationIndex) throws IOException {
        if (outputFolder != null && !outputFolder.isEmpty()) {
            // Generate metanorma.yml in the root of path
            StringBuilder metanormaYml = new StringBuilder();
            metanormaYml.append("---").append("\n")
                    .append("metanorma:").append("\n")
                    .append("  source:").append("\n")
                    .append("    files:").append("\n");

            Path pathOutputFolder = Paths.get(outputFolder);
            URI pathRootFolderURI = pathOutputFolder.toUri();

            List<Map.Entry<String,String>> docFolders = new ArrayList<>();
            for (Map.Entry<String, String> entry : inputOutputFiles) {
                String resultAdoc = entry.getValue();
                String parentFolder = new File(resultAdoc).getParentFile().getName();
                if (parentFolder.contains(Constants.ISO_STANDARD_PREFIX)) {
                    parentFolder = parentFolder.substring(parentFolder.indexOf(Constants.ISO_STANDARD_PREFIX) + Constants.ISO_STANDARD_PREFIX.length());
                }
                docFolders.add(new AbstractMap.SimpleEntry<>(parentFolder, resultAdoc));
            }

            Collections.sort(docFolders, new Comparator<Map.Entry<String, String>>() {
                public int compare(Map.Entry<String, String> a, Map.Entry<String, String> b){
                    Integer aInt = toNumeric(a.getKey());
                    Integer bInt = toNumeric(b.getKey());
                    if (aInt != -1 && bInt != -1) {
                        return aInt.compareTo(bInt);
                    } else {
                        return a.getKey().compareTo(b.getKey());
                    }
                }
                public int toNumeric(String strNum) {
                    if (strNum == null) {
                        return -1;
                    }
                    try {
                        int i = Integer.parseInt(strNum);
                        return i;
                    } catch (NumberFormatException nfe) {
                        return -1;
                    }
                }
            }
            );

            for (Map.Entry<String, String> entry : docFolders) {
                String resultAdoc = entry.getValue();
                URI resultAdocURI = Paths.get(resultAdoc).toUri();
                URI relativeURI = pathRootFolderURI.relativize(resultAdocURI);
                metanormaYml.append("      - " + relativeURI).append("\n");
            }
            metanormaYml.append("\n")
                    .append("  collection:").append("\n")
                    .append("    organization: " + ORGANIZATION).append("\n")
                    .append("    name: " + NAME).append("\n");

            Files.createDirectories(pathOutputFolder);

            if (namePublicationIndex == null) {
                namePublicationIndex = "";
            }
            if (!namePublicationIndex.isEmpty()) {
                namePublicationIndex = namePublicationIndex + ".";
            }

            //append string buffer/builder to buffered writer
            Path pathMetanormaYml = Paths.get(outputFolder, namePublicationIndex + "metanorma.yml");
            BufferedWriter writer = new BufferedWriter(new FileWriter(pathMetanormaYml.toFile()));
            writer.write(metanormaYml.toString());
            writer.close();
            System.out.println("[INFO] Saved " + pathMetanormaYml.toString() + ".");
        }
    }
}
