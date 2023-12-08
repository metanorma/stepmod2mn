package org.metanorma;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

public class CustomErrorListener implements ErrorListener {
    public void warning(TransformerException exception) throws TransformerException {
        String msg = exception.getMessage();
        // the message from Xalan: the function document(...) can't load the xml
        if (msg.startsWith("Can not load")) {
            msg = "[ERROR] " + msg;
        }
        System.out.println(msg);
    }

    public void error(TransformerException exception) throws TransformerException {
        System.err.println(exception.getMessageAndLocation());
    }

    public void fatalError(TransformerException exception) throws TransformerException {
        System.err.println(exception.getMessageAndLocation());
    }
}
