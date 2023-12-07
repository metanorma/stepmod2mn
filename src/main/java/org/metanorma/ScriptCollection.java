package org.metanorma;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

// Generate collection.sh
// The script to process each part, and generate the overall collection
// see https://github.com/metanorma/annotated-express/issues/134
public class ScriptCollection {

    List<Map.Entry<String,String>> inputOutputFiles;

    String outputPath;

    public ScriptCollection(String outputPath, List<Map.Entry<String,String>> inputOutputFiles) {
        this.outputPath = outputPath;
        this.inputOutputFiles = inputOutputFiles;
    }

    public void generate() throws IOException {
        // get repository root folder from 1st file
        String repositoryRootFolder = Util.getRepositoryRootFolder(inputOutputFiles.get(0).getValue());
        if (repositoryRootFolder.isEmpty() && outputPath != null && !outputPath.isEmpty()) {
            String parentOutputPath = new File(outputPath).getParent();
            repositoryRootFolder = parentOutputPath;
        }
        if(!repositoryRootFolder.isEmpty()) {
            String documentFolder = new File(inputOutputFiles.get(0).getValue()).getParent();
            String documentRelativeFolder = Util.getRelativePath(repositoryRootFolder, documentFolder);
            String documentsFolder = new File(documentFolder).getParent();
            String documentsRelativeFolder = Util.getRelativePath(documentsFolder, repositoryRootFolder);

            StringBuilder sbScript = new StringBuilder();
            sbScript.append("INPUT_REPOS=\"");
            List<String> repos = new ArrayList<>();
            for (Map.Entry<String,String> entry: inputOutputFiles) {
                //File f = new File(entry.getKey());
                File f = new File(entry.getValue());
                repos.add(f.getParentFile().getName());
            }
            sbScript.append(repos.toString()
                    .replace("[", "")
                    .replace("]", "")
                    .replace(" ", "")
                    .replace(","," ")).append("\"\n\n");

            String paramW = "iso10303-output";
            if (outputPath != null && !outputPath.isEmpty()) {
                paramW = outputPath.replace("\\","/") + "/output";
            }

            sbScript.append("for name in $INPUT_REPOS").append("\n")
            .append("do").append("\n")
            .append("  echo $name").append("\n")
                    //  cd data/resource_docs/$name
            .append("  cd ").append(documentsRelativeFolder).append("/$name").append("\n")
            .append("  sh ./html_attachments.sh").append("\n")
            .append("  bundle exec metanorma -x xml document.adoc").append("\n")
            //  cd  ../../.."
            .append("  cd  ").append(documentRelativeFolder).append("\n")
            .append("done").append("\n")
            .append("bundle exec metanorma collection collection.yml -x xml,html,presentation -w ").append(paramW).append(" -c cover.html").append("\n");

            BufferedWriter writer = new BufferedWriter(new FileWriter(Paths.get(repositoryRootFolder, "collection.sh").toFile()));
            writer.write(sbScript.toString());
            writer.close();
        }
    }
}
