package org.metanorma;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;

import java.io.*;
import java.nio.file.Paths;
import java.util.*;

// To generate the collection manifest
// see https://github.com/metanorma/annotated-express/issues/134
public class MetanormaCollectionManifest {

    List<Map.Entry<String,String>> inputOutputFiles;

    Map<String, Object> yamlObj = new LinkedHashMap<>();

    public MetanormaCollectionManifest(List<Map.Entry<String,String>> inputOutputFiles) {
        this.inputOutputFiles = inputOutputFiles;
        try {
            Yaml yaml = new Yaml();
            InputStream inputStream = Util.getStreamFromResources(stepmod2mn.class.getClassLoader(), "collection_template.yml");
            yamlObj = yaml.load(inputStream);
            //System.out.println(yamlObj);
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
    }

    public void generate() throws IOException {
        // get repository root folder from 1st file
        String repositoryRootFolder = Util.getRepositoryRootFolder(inputOutputFiles.get(0).getValue());
        if (!repositoryRootFolder.isEmpty()) {
            int counter = 0;
            for (Map.Entry<String, String> entry : inputOutputFiles) {
                String resultAdoc = entry.getValue();
                String documentFolder = new File(resultAdoc).getParent();
                File fileResultCollectionYml = Paths.get(documentFolder, "collection.yml").toFile();
                InputStream is = new FileInputStream(fileResultCollectionYml);
                Yaml yaml = new Yaml();
                Map<String, Object> yamlDocumentObj = yaml.load(is);
                //System.out.println(yamlDocumentObj);

                // manifest:
                //  - level: document
                update_docref(yamlDocumentObj,0, documentFolder);

                // manifest:
                //  - level: attachments
                update_docref(yamlDocumentObj,1, documentFolder);

                counter++;
            }

            DumperOptions options = new DumperOptions();
            options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
            Yaml yaml = new Yaml(options);
            PrintWriter writer = new PrintWriter(Paths.get(repositoryRootFolder, "collection.yml").toFile());
            yaml.dump(yamlObj, writer);
        }
    }

    private void update_docref(Map<String, Object> yamlDocumentObj, int num, String documentFolder) {
        ArrayList docref =
                ((ArrayList<Object>)
                        ((LinkedHashMap <String, Object>)
                                ((ArrayList<Object>)
                                        ((LinkedHashMap <String, Object>)
                                                yamlDocumentObj.get("manifest"))
                                                .get("manifest"))
                                        .get(num))
                                .get("docref"));
        for (int i = 0; i < docref.size(); i++) {
            Map <String, Object> items = (LinkedHashMap <String, Object>)docref.get(i);
            String fileref = (String)items.get("fileref");

            String fullPath = Paths.get(documentFolder, fileref).toFile().getAbsolutePath().replace("\\","/");
            items.put("fileref",fullPath);

            // add updated structure into yaml object
            ArrayList template_docref =
                    ((ArrayList<Object>)
                            ((LinkedHashMap <String, Object>)
                                    ((ArrayList<Object>)
                                            ((LinkedHashMap <String, Object>)
                                                    yamlObj.get("manifest"))
                                                    .get("manifest"))
                                            .get(num))
                                    .get("docref"));
            if (template_docref == null) {
                template_docref = new ArrayList<>();
            }
            template_docref.add(items);
            ((LinkedHashMap <String, Object>)
                    ((ArrayList<Object>)
                            ((LinkedHashMap <String, Object>)
                                    yamlObj.get("manifest"))
                                    .get("manifest"))
                            .get(num))
                    .put("docref",template_docref);
        }
    }
}
