package org.metanorma;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestName;

import java.util.List;

import static org.junit.Assert.assertTrue;

/**
 *
 * @author Alexander Dyuzhev
 */
public class PublicationIndexTests {

    @Rule
    public TestName name = new TestName();

    @Test
    public void test1() {
        System.out.println(name.getMethodName());
        ClassLoader classLoader = getClass().getClassLoader();
        String xml = classLoader.getResource("test.publication_index.xml").getFile();
        PublicationIndex publicationIndex = new PublicationIndex(xml);
        List<String> listResourcesPaths = publicationIndex.getDocumentsPaths("resource_docs");
        assertTrue(listResourcesPaths.size() == 2);
        List<String> listModulesPaths = publicationIndex.getDocumentsPaths("modules");
        assertTrue(listModulesPaths.size() == 1);
        List<String> listPaths = publicationIndex.getDocumentsPaths("");
        assertTrue(listPaths.size() == 3);
    }
}
