package org.metanorma;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class RepositoryIndex {

    private String filename;
    private final String REPOSITORY_INDEX_FILENAME = "repository_index.xml";

    private String sRepositoryIndex = "";

    public RepositoryIndex(String startFolder) {
        init(startFolder);
    }

    private void init(String startFolder) {
        // find repository_index.xml in the current folder and parents folders

        File f = new File(startFolder);
        if (!f.isDirectory()) {
            startFolder = f.getParent();
        }

        boolean endFoldersTree = false;

        Path repositoryIndexPath = Paths.get(startFolder, REPOSITORY_INDEX_FILENAME);

        while (!Files.exists(repositoryIndexPath) && !endFoldersTree) {
            try {
                repositoryIndexPath = Paths.get(repositoryIndexPath.getParent().getParent().toString(), REPOSITORY_INDEX_FILENAME);

            } catch (Exception ex) {
                System.err.println("Can't find the repository index '" + REPOSITORY_INDEX_FILENAME + "'.");
                endFoldersTree = true;
            }
        }
        if (endFoldersTree) {
            filename = "";
        } else {
            filename = repositoryIndexPath.toString();
            sRepositoryIndex = XMLUtils.processLinearizedXML(filename);
        }
    }

    public String getPath() {
        return filename;
    }

    public boolean contains(String documentName, String documentKind) {
        if (!sRepositoryIndex.isEmpty()) {
            if (documentKind.equals("resource")) {
                documentKind = "resource_doc";
            }
            //DEBUG: documentName = "fundamentals_of_product_description_and_support";
            String xPath = "//" + documentKind + "[@name = '" + documentName + "']/@name";
            String result = XMLUtils.getTextByXPath(sRepositoryIndex, xPath);
            return !result.isEmpty();
        }
        return true;
    }

    public boolean isWithdrawn(String documentName, String documentKind) {
        if (!sRepositoryIndex.isEmpty()) {
            if (documentKind.equals("resource")) {
                documentKind = "resource_doc";
            }
            String xPath = "//" + documentKind + "[@name = '" + documentName + "' and @status = 'withdrawn']/@name";
            String result = XMLUtils.getTextByXPath(sRepositoryIndex, xPath);
            return !result.isEmpty();
        }
        return false;
    }

}
