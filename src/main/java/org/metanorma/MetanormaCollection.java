package org.metanorma;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

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
    public void generate(String outputFolder) throws IOException {
        if (outputFolder != null && !outputFolder.isEmpty()) {
            // Generate metanorma.yml in the root of path
            StringBuilder metanormaYml = new StringBuilder();
            metanormaYml.append("---").append("\n")
                    .append("metanorma:").append("\n")
                    .append("  source:").append("\n")
                    .append("    files:").append("\n");

            URI pathRootFolderURI = Paths.get(outputFolder).toUri();
            for (Map.Entry<String, String> entry : inputOutputFiles) {
                String resultAdoc = entry.getValue();
                URI resultAdocURI = Paths.get(resultAdoc).toUri();
                URI relativeURI = pathRootFolderURI.relativize(resultAdocURI);
                metanormaYml.append("      - " + relativeURI).append("\n");
            }
            metanormaYml.append("\n")
                    .append("  collection:").append("\n")
                    .append("    organization: " + ORGANIZATION).append("\n")
                    .append("    name: " + NAME).append("\n");

            //append string buffer/builder to buffered writer
            BufferedWriter writer = new BufferedWriter(new FileWriter(Paths.get(outputFolder, "metanorma.yml").toFile()));
            writer.write(metanormaYml.toString());
            writer.close();
        }
    }
}
