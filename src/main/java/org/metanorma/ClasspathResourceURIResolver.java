package org.metanorma;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

public class ClasspathResourceURIResolver implements URIResolver {
    public Source resolve(String href, String base) throws TransformerException {
        return new StreamSource(getClass().getClassLoader().getResourceAsStream(href));
    }
}

