package com.metanorma;

import static org.junit.Assert.assertTrue;
import org.junit.Test;


/**
 *
 * @author Alexander Dyuzhev
 */
public class regexescapingTests {
    
    @Test
    public void testRule1() {
        String text = "Text _abc_, text.";
        String expectedResult = "Text \\_abc_, text.";
        String result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
        
        text = "Text a_bc_ text";
        expectedResult = text;
        result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
        
        text = "Text _abc text";
        expectedResult = text;
        result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
    }
    
    @Test
    public void testRule2() {
        String text = "Text a__b__c_d text.";
        String expectedResult = "Text a\\__b__c_d text.";
        String result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
        
        text = "Text __abc text";
        expectedResult = text;
        result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
        
        text = "Text _abc text";
        expectedResult = text;
        result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
        
        text = "Text a^^b^^c^d text.";
        expectedResult = "Text a\\^^b^^c^d text.";
        result = RegExEscaping.escapeFormattingCommands(text);
        assertTrue(result.equals(expectedResult));
    }
    
}
