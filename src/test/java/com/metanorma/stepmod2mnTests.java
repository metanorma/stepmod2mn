package com.metanorma;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.apache.commons.cli.ParseException;

import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import static org.junit.Assert.assertTrue;

import org.junit.contrib.java.lang.system.EnvironmentVariables;
import org.junit.contrib.java.lang.system.ExpectedSystemExit;
import org.junit.contrib.java.lang.system.SystemOutRule;
import org.junit.rules.TestName;

public class stepmod2mnTests {

    static String XMLFILE_STEPMOD;
    
    @Rule
    public final ExpectedSystemExit exitRule = ExpectedSystemExit.none();

    @Rule
    public final SystemOutRule systemOutRule = new SystemOutRule().enableLog();

    @Rule
    public final EnvironmentVariables envVarRule = new EnvironmentVariables();

    @Rule public TestName name = new TestName();
    
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        XMLFILE_STEPMOD = System.getProperty("inputXML");
        if (XMLFILE_STEPMOD == null) {
            System.out.println("Environment variable 'inputXML' is empty!");
        }
    }
    
    @Test
    public void notEnoughArguments() throws ParseException {
        System.out.println(name.getMethodName());
        exitRule.expectSystemExitWithStatus(-1);
        String[] args = new String[]{""};
        stepmod2mn.main(args);

        assertTrue(systemOutRule.getLog().contains(stepmod2mn.USAGE));
    }

    
    @Test
    public void xmlNotExists() throws ParseException {
        System.out.println(name.getMethodName());
        exitRule.expectSystemExitWithStatus(-1);

        String[] args = new String[]{"nonexist.xml"};
        stepmod2mn.main(args);

        assertTrue(systemOutRule.getLog().contains(
                String.format(stepmod2mn.INPUT_NOT_FOUND, stepmod2mn.XML_INPUT, args[1])));
    }
    

    @Test
    public void successConvertToAdoc() throws ParseException {
        System.out.println(name.getMethodName());
        String outFileName = new File(XMLFILE_STEPMOD).getAbsolutePath();
        outFileName = outFileName.substring(0, outFileName.lastIndexOf('.') + 1);
        Path fileout = Paths.get(outFileName + "adoc");
        fileout.toFile().delete();
        
        String[] args = new String[]{XMLFILE_STEPMOD};
        stepmod2mn.main(args);

        assertTrue(Files.exists(fileout));        
    }

    @Test
    public void pathNotExists() throws ParseException {
        System.out.println(name.getMethodName());
        exitRule.expectSystemExitWithStatus(-1);

        String[] args = new String[]{"nonexistingpath", "-svg"};
        stepmod2mn.main(args);

        assertTrue(systemOutRule.getLog().contains(
                String.format(stepmod2mn.INPUT_PATH_NOT_FOUND, stepmod2mn.XML_INPUT, args[1])));
    }
 
    @Test
    public void successConvertToSVG() throws ParseException {
        String svgPath = System.getProperty("buildDirectory") + File.separator + ".." 
                + File.separator + "src"
                + File.separator + "test"
                + File.separator + "resources"
                + File.separator + "svg";
        
        String[] args = new String[]{svgPath , "-svg"};
        stepmod2mn.main(args);

        assertTrue(Files.exists(Paths.get(svgPath + File.separator + "schemaexpg1.svg")));
    }
    
    @Test
    public void successConvertToSVGOne() throws ParseException {
        String svgPath = System.getProperty("buildDirectory") + File.separator + ".." 
                + File.separator + "src"
                + File.separator + "test"
                + File.separator + "resources"
                + File.separator + "svg";
        String svgFile = svgPath + File.separator + "schemaexpg1.xml";
        String image = "schemaexpg1.gif";
        
        String[] args = new String[]{"-x" , svgFile , "-i", image};
        stepmod2mn.main(args);

        assertTrue(Files.exists(Paths.get(svgPath + File.separator + "schemaexpg1.svg")));
    }
}
