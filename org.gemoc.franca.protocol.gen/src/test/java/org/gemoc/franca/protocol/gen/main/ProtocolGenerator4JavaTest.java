package org.gemoc.franca.protocol.gen.main;

import org.gemoc.franca.protocol.gen.generator.AbstractProtocolGenerator;
import org.gemoc.franca.protocol.gen.generator.java.ProtocolGenerator4Java;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * test for ProtocolGenerator4Java.
 */
public class ProtocolGenerator4JavaTest 
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public ProtocolGenerator4JavaTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( ProtocolGenerator4JavaTest.class );
    }

    /**
     * 
     */
    public void testGenerateEAOP()
    {
    	//String fdeplFile = "/home/dvojtise/git/github_gemoc/franca-gen/examples/org.gemoc.franca.examples.eaop.wsjsonrpc.protocol/models/org/gemoc/franca/examples/eaop/wsjsonrpc/deploy/eaopDeploy.fdepl";
    	String fdeplFile = System.getProperty("user.dir") +"/../examples/org.gemoc.franca.examples.eaop.wsjsonrpc.protocol/models/org/gemoc/franca/examples/eaop/wsjsonrpc/deploy/eaopDeploy.fdepl";
		String outFolder = "target/tmp";
    	AbstractProtocolGenerator generator =  new ProtocolGenerator4Java(fdeplFile, outFolder);
    	generator.generate();
        //assertTrue( true );
        
    }
}
