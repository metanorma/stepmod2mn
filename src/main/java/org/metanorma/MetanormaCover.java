package org.metanorma;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

// To generate the cover page
// see https://github.com/metanorma/annotated-express/issues/134
public class MetanormaCover {


    List<Map.Entry<String,String>> inputOutputFiles;

    String outputPath;

    public MetanormaCover(String outputPath, List<Map.Entry<String,String>> inputOutputFiles) {
        this.outputPath = outputPath;
        this.inputOutputFiles = inputOutputFiles;
    }

    public void generate() throws IOException {
        // get repository root folder from 1st file
        String repositoryRootFolder = Util.getRepositoryRootFolder(inputOutputFiles.get(0).getValue());
        if (repositoryRootFolder.isEmpty() && outputPath != null) {
            String parentOutputPath = new File(outputPath).getParent();
            repositoryRootFolder = parentOutputPath;
        }
        StringBuilder sbCover = new StringBuilder();

        sbCover.append("<html><head><meta charset=\"UTF-8\"/></head><body>\n" +
                "  <h1>{{ doctitle }}</h1>\n" +
                "  <h2>{{ docnumber }}</h2>\n" +
                "  <nav>{{ nav_object['children'][0]['docrefs'] }}</nav>\n" +
                " </body></html>");

        BufferedWriter writer = new BufferedWriter(new FileWriter(Paths.get(repositoryRootFolder, "cover.html").toFile()));
        writer.write(sbCover.toString());
        writer.close();
    }
}
