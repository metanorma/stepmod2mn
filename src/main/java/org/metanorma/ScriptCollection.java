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

    public ScriptCollection(List<Map.Entry<String,String>> inputOutputFiles) {
        this.inputOutputFiles = inputOutputFiles;
    }

    public void generate() throws IOException {
        // get repository root folder from 1st file
        String repositoryRootFolder = Util.getRepositoryRootFolder(inputOutputFiles.get(0).getValue());

        String documentFolder = new File(inputOutputFiles.get(0).getValue()).getParent();
        String documentRelativeFolder = Util.getRelativePath(repositoryRootFolder, documentFolder);
        String documentsFolder = new File(documentFolder).getParent();
        String documentsRelativeFolder = Util.getRelativePath(documentsFolder, repositoryRootFolder);

        StringBuilder sbScript = new StringBuilder();
        sbScript.append("INPUT_REPOS=\"");
        List<String> repos = new ArrayList<>();
        for (Map.Entry<String,String> entry: inputOutputFiles) {
            File f = new File(entry.getKey());
            repos.add(f.getParentFile().getName());
        }
        sbScript.append(repos.toString()
                .replace("[", "")
                .replace("]", "")
                .replace(" ", "")
                .replace(","," ")).append("\"\n\n");

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
        .append("bundle exec metanorma collection collection.yml -x xml,html,presentation -w iso10303-output -c cover.html").append("\n");

        BufferedWriter writer = new BufferedWriter(new FileWriter(Paths.get(repositoryRootFolder, "collection.sh").toFile()));
        writer.write(sbScript.toString());
        writer.close();
    }
}
