package org.gemoc.franca.protocol.gen.plugin;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.codehaus.plexus.util.DirectoryScanner;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.eclipse.xtext.validation.Issue;
import org.franca.deploymodel.dsl.FDeployStandaloneSetup;
import org.franca.deploymodel.dsl.generator.FDeployGenerator;
import org.gemoc.franca.protocol.gen.generator.AbstractProtocolGenerator;
import org.gemoc.franca.protocol.gen.generator.GeneratorKind;
import org.gemoc.franca.protocol.gen.generator.java.ProtocolGenerator4Java;

import com.google.inject.Inject;
import com.google.inject.Provider;

/**
 * Goal which generates Franca deployment accessors from franca deployment specifications.
 */
@Mojo( name = "generate", defaultPhase = LifecyclePhase.GENERATE_SOURCES )
public class FrancaProtocolGenMojo extends AbstractMojo
{
	/**
	 * Get access to the Maven project.
	 */
	@Parameter(defaultValue = "${project}", required = true)
	private MavenProject project;

	/**
	 * If set to true then Maven will print "path: compiling" for each root directory
	 * or files that are processed.
	 */
	@Parameter(defaultValue = "true", property = "notifyCompilation", required = true)
	private boolean notifyCompilation;

	/**
	 * Location of the base output directory to generate to.
	 */
	@Parameter(defaultValue = "${project.build.directory}", property = "outputDir", required = true)
	private File outputDirectory;

	/**
	 * Set an include filter for source files.
	 * 
	 * If empty a default filter for Franca deployment files will be used.
	 */
	@Parameter(defaultValue = "", property = "includes", required = true)
	private Set<String> includes;

	/**
	 * Set an exclude filter for source files.
	 */
	@Parameter(defaultValue = "", property = "excludes", required = true)
	private Set<String> excludes;

	/**
	 *  name of generator to use 
	 *  Default: java
	 */
    @Parameter(defaultValue = "java")
    private String generator;
    
    /**
	 *  fdepl file
	 */
    @Parameter()
    private File fdeplFile;
	
/*
	@Inject
	private Provider<ResourceSet> resourceSetProvider;

	@Inject
	private FDeployGenerator generator;

	@Inject
	private JavaIoFileSystemAccess fileSystemAccess;
*/

	public void execute() throws MojoExecutionException
	{
		System.out.println("FrancaProtocolGenMojo.execute()");
		getLog().info("FrancaProtocolGenMojo.execute()");
		getLog().debug("Using output directory " + outputDirectory.getAbsolutePath());
		
		
		

		// Collect the source directories to search Franca deployment files in.
		List<File> sourceDirs = getSourceRoots(project.getResources());

		// Create the output directory if required.
		if (!outputDirectory.exists()) {
			getLog().debug("Creating output directory " + outputDirectory.getAbsolutePath());
			outputDirectory.mkdirs();
		}

		// Add the output directory to the project's source directories so that the generated
		// files are compiled by the Java compiler.
		project.addCompileSourceRoot(outputDirectory.getAbsolutePath());

		
		if(fdeplFile != null ) {
			getLog().debug("Generating Franca deployment accessors for " + fdeplFile.getAbsolutePath());
			try {
				getLog().info("Generating Franca deployment accessors for " + fdeplFile.getCanonicalPath());
				fdeplFile = fdeplFile.getCanonicalFile();
			} catch (IOException e) {
				throw new MojoExecutionException(e.getMessage(), e);
			}
			generate(fdeplFile, outputDirectory);
		} else {
			// Find Franca deployment files to process.
			List<File> fdeplFiles = findFdeplFiles(sourceDirs);
	
			// Generate Franca deployment accessors.
			if (!fdeplFiles.isEmpty()) {
				generate(fdeplFiles);
			}
		}
	}

	private List<File> findFdeplFiles(List<File> sourceDirs) {
		DirectoryScanner scanner = new DirectoryScanner();
		if (includes.isEmpty()) {
			includes.add("**/*.fdepl");
		}
		scanner.setIncludes(includes.toArray(new String[includes.size()]));
		if (!excludes.isEmpty()) {
			scanner.setExcludes(excludes.toArray(new String[excludes.size()]));
		}

		List<File> fdeplFiles = new ArrayList<File>();
		for (File sourceDirectory: sourceDirs) {
			if (sourceDirectory.isDirectory()) {
				scanner.setBasedir(sourceDirectory);
				scanner.scan();
				for (String file: scanner.getIncludedFiles()) {
					File fdepl = new File(sourceDirectory, file);
					fdeplFiles.add(fdepl);
					getLog().debug("Found Franca deployment file " + fdepl.getAbsolutePath());
				}
			}
		}

		return fdeplFiles;
	}

	private void generate(List<File> fdeplFiles) throws MojoExecutionException {
		getLog().info("Generating Franca deployment accessors for " + fdeplFiles.size() + " files.");
		new FDeployStandaloneSetup().createInjectorAndDoEMFRegistration().injectMembers(this);
		for (File fdepl: fdeplFiles) {
			getLog().debug("Generating Franca deployment accessors for " + fdepl.getAbsolutePath());
			generate(fdepl, outputDirectory);
		}
	}

	private void generate(File fdepl, File outputDirectory) throws MojoExecutionException {
		
		
		AbstractProtocolGenerator generator = null;
		try {
			GeneratorKind generatorKindenum  = GeneratorKind.valueOf(this.generator);
			switch (generatorKindenum) {
			case java:
				generator =  new ProtocolGenerator4Java(fdepl.getAbsolutePath(), outputDirectory.getAbsolutePath());
				break;
			default:
				String msgErr="generator "+generatorKindenum.name() + " not implemented";
				getLog().error("generator "+generatorKindenum.name() + " not implemented");
				throw new MojoExecutionException(msgErr);
			}
			//generator.generate();
		} catch (java.lang.IllegalArgumentException e) {
			System.err.println("Unknown generator "+this.generator);
			throw new MojoExecutionException("Unknown generator "+this.generator);
		}
		
		getLog().debug("Validating " + fdepl.getAbsolutePath()+"...");
		Resource fdeplResource = generator.fdmodel.eResource();
		
		IResourceValidator fModelValidator =
				((XtextResource) fdeplResource)
				.getResourceServiceProvider()
				.getResourceValidator();
		List<Issue> issues = fModelValidator.validate(fdeplResource, CheckMode.ALL, CancelIndicator.NullImpl);

		boolean hasErrors = false;
		StringBuilder errorString = new StringBuilder();
		for (Issue issue : issues) {
			if (issue.getSeverity() == Severity.ERROR) {
				errorString.append(issue.toString());
				hasErrors = true;
			}
			getLog().error(issue.toString());
		}
		// Abort the build on validation errors.
		if (hasErrors) {
			getLog().debug("Validation failed " + fdepl.getAbsolutePath()+"...");
			throw new MojoExecutionException(errorString.toString());
		}
		getLog().debug("fdepl validated  " + fdepl.getAbsolutePath());
    	generator.generate();
		
	}

	private List<File> getSourceRoots(List<org.apache.maven.model.Resource> list) {
		List<File> sourceRoots = new ArrayList<File>();
		for (org.apache.maven.model.Resource sourceRootStr: list) {
			File sourceRoot = new File(sourceRootStr.getDirectory());
			if (sourceRoot.equals(outputDirectory)) {
				getLog().debug("Skipping output directory " + sourceRootStr);
			}
			else if (sourceRoot.isDirectory()) {
				getLog().debug("Using source directory " + sourceRootStr);
				sourceRoots.add(sourceRoot);
			}
			else {
				getLog().info("Skipping non existent source directory " + sourceRootStr);
			}
		}

		return sourceRoots;
	}
}
