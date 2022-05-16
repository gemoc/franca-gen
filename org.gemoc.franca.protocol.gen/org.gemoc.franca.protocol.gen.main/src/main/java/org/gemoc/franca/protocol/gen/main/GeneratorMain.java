package org.gemoc.franca.protocol.gen.main;


import java.util.List;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.franca.core.dsl.FrancaPersistenceManager;
import org.franca.core.franca.FModel;
import org.franca.core.franca.FTypeCollection;
import org.franca.deploymodel.core.FDModelExtender;
import org.franca.deploymodel.core.FDeployedInterface;
import org.franca.deploymodel.dsl.FDeployPersistenceManager;
import org.franca.deploymodel.dsl.fDeploy.FDInterface;
import org.franca.deploymodel.dsl.fDeploy.FDModel;
import org.franca.deploymodel.dsl.tests.FDeployInjectorProvider;

import com.google.inject.Inject;


public class GeneratorMain {
	
	public static String outputDir = "src-gen";
	//public static String srcGenDir = "src-gen";

	public static String  fdeployInterfaceFile =
			"fr/inria/diverse/francaTest/deploy/eaopDeploy.fdepl";
	
	public static String  fidlEaopFile =
			"fr/inria/diverse/francaTest/idl/eaop.fidl";

	public static void main(String[] args) {
		FDeployInjectorProvider fDeployInjectorProvider = new FDeployInjectorProvider();
		FDeployPersistenceManager loader= fDeployInjectorProvider.getInjector().getInstance(FDeployPersistenceManager.class);
		System.out.println("*** DeployGeneratorTest / Interface Generation");

		// load example Franca IDL interface
		String inputfile = fdeployInterfaceFile; 
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

}
