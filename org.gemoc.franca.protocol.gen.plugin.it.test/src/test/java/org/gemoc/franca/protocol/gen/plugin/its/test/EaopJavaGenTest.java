package org.gemoc.franca.protocol.gen.plugin.its.test;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.maven.it.Verifier;
import org.apache.maven.it.util.ResourceExtractor;

import junit.framework.TestCase;

/*
 * Cf. https://maven.apache.org/plugin-developers/plugin-testing.html
 */

public class EaopJavaGenTest extends TestCase
{
    public void testMyPlugin()
        throws Exception
    {
        // Check in your dummy Maven project in /src/test/resources/...
        // The testdir is computed from the location of this
        // file.
        File testDir = ResourceExtractor.simpleExtractResources( getClass(), "/EaopJavaGen" );
 
        Verifier verifier;
 
        
        /*
         * We must first make sure that any artifact created
         * by this test has been removed from the local
         * repository. Failing to do this could cause
         * unstable test results. Fortunately, the verifier
         * makes it easy to do this.
         */
        verifier = new Verifier( testDir.getAbsolutePath() , true);
        
        System.out.println("localRepository="+verifier.getLocalRepository());
        System.out.println("EaopJavaGenTest logFileName="+verifier.getBasedir() +"/"+verifier.getLogFileName());
        
        //verifier.displayStreamBuffers();
        //verifier.setLocalRepo(getName())
        
        //verifier.deleteArtifact( "org.apache.maven.its.itsample", "parent", "1.0", "pom" );
        //verifier.deleteArtifact( "org.apache.maven.its.itsample", "checkstyle-test", "1.0", "jar" );
        //verifier.deleteArtifact( "org.apache.maven.its.itsample", "checkstyle-assembly", "1.0", "jar" );
        verifier.deleteArtifact( "org.gemoc.franca.protocol.gen.plugin.its.eaopjavagen", "eaopjavagen", "1.0", "java" );
 
        /*
         * The Command Line Options (CLI) are passed to the
         * verifier as a list. This is handy for things like
         * redefining the local repository if needed. In
         * this case, we use the -N flag so that Maven won't
         * recurse. We are only installing the parent pom to
         * the local repo here.
         */
        List<String> cliOptions = new ArrayList<String>();
        cliOptions.add( "-N" );
        verifier.setCliOptions(cliOptions);
        verifier.executeGoal( "install" );
 
        /*
         * This is the simplest way to check a build
         * succeeded. It is also the simplest way to create
         * an IT test: make the build pass when the test
         * should pass, and make the build fail when the
         * test should fail. There are other methods
         * supported by the verifier. They can be seen here:
         * http://maven.apache.org/shared/maven-verifier/apidocs/index.html
         */
        verifier.verifyErrorFreeLog();
 
        /*
         * Reset the streams before executing the verifier
         * again.
         */
        verifier.resetStreams();
 
        /*
         * The verifier also supports beanshell scripts for
         * verification of more complex scenarios. There are
         * plenty of examples in the core-it tests here:
         * https://svn.apache.org/repos/asf/maven/core-integration-testing/trunk
         */
        
    }
}
