package org.gemoc.franca.protocol.gen.main;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Set;
import java.util.Map.Entry;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;

import org.franca.deploymodel.core.FDModelExtender;
import org.franca.deploymodel.core.FDeployedInterface;
import org.franca.deploymodel.dsl.FDeployPersistenceManager;
import org.franca.deploymodel.dsl.FDeployStandaloneSetup;
import org.franca.deploymodel.dsl.fDeploy.FDInterface;
import org.franca.deploymodel.dsl.fDeploy.FDModel;
import org.franca.core.franca.FModel;
import org.franca.core.franca.FTypeCollection;
import org.reflections.Reflections;
import org.reflections.scanners.ResourcesScanner;
import org.reflections.scanners.Scanner;
import org.reflections.scanners.Scanners;
import org.reflections.scanners.Scanners.*;
import org.reflections.util.ConfigurationBuilder;
import org.reflections.util.FilterBuilder;

import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Injector;

import org.franca.core.dsl.FrancaImportsProvider;
import org.franca.core.dsl.FrancaPersistenceManager;
import javassist.bytecode.ClassFile;


public class GeneratorMain {

	public static String outputDir = "src-gen";
	// public static String srcGenDir = "src-gen";

	
	public static void main(String[] args) {
		//javax.enterprise.inject.spi.CDI.current().getBeanManager().select(FDeployPersistenceManager.class).get();
		FDeployInjectorProvider fDeployInjectorProvider = new FDeployInjectorProvider();

		FDeployPersistenceManager loader = fDeployInjectorProvider.getInjector().getInstance( FDeployPersistenceManager.class);
		

		//FDeployPersistenceManager loader= fDeployInjectorProvider.getInjector().getInstance(FDeployPersistenceManager.class);
		System.out.println("*** DeployGeneratorTest / Interface Generation");

		// load example Franca IDL interface
		String inputfile = (String) getDeployUri().iterator().next(); 
    	URI root = URI.createURI("classpath:/");
    	URI loc = URI.createFileURI(inputfile);
		FDModel fdmodel = loader.loadModel(loc, root);
		
		
		// get first interface referenced by FDeploy model
		FDModelExtender fdmodelExt = new FDModelExtender(fdmodel);
		List<FDInterface> interfaces = fdmodelExt.getFDInterfaces();
		FDInterface api = interfaces.get(0);
		
		
	
		//FDeployedTypeCollection tc = new FDeployedTypeCollection(api.getTypes())
		// create wrapper and generate code from it 
		FDeployedInterface deployed = new FDeployedInterface(api);
		JrpcInterfaceGen generator =
				new JrpcInterfaceGen();
		String code = generator.generateInterface(deployed,"org.eclipse.gemoc.protocols.eaop.api").toString();
		
		// simply print the generated code to console
		System.out.println("Generated code:\n" + code);
		System.out.println("-----------------------------------------------------");
		
		
		EList<Resource> rs = api.eResource().getResourceSet().getResources();
		

		Resource fModelResource = rs.stream().filter(r -> r.getContents().get(0) instanceof FModel).findAny().get();
		FModel fmodel = (FModel) fModelResource.getContents().get(0);
		List<FTypeCollection> l =fmodel.getTypeCollections();
		System.out.println(l.get(0).eClass());
		System.out.println(l.get(0).eContents().get(0));
		System.out.println(l.get(0).eContents().get(0).eContents());

		JrpcDtoGen dtoGenerator = new JrpcDtoGen();
		code = dtoGenerator.generateDtoClass(l, "org.eclipse.gemoc.protocols.eaop.api").toString();
		// simply print the generated code to console		
		System.out.println("Generated code:\n" + code);
		System.out.println("-----------------------------------------------------");



	}
	
	private static Set<String> getFdeplUri() {
		Reflections reflections = new Reflections(
				  new ConfigurationBuilder()
				    .forPackage("org.gemoc.franca.protocol.lib")
				    .addScanners(Scanners.Resources));
		//getResources only filters on the resource name and returns the full path, I can't use this regex to filter on the path ... weird, isn't it ?
		return reflections.getResources(Pattern.compile(".*fdepl"));
	}
	
	/**
	 * Find the deploy files on the classpath, ie the .fdepl files located in deploy folder
	 * @return A Set<String> which are file uri
	 */
	private static Set<String> getDeployUri() {
		return getFdeplUri().stream().filter(uri -> uri.contains("/deploy/")).collect(Collectors.toSet());
	}
	
	

}