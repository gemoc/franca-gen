package org.gemoc.franca.protocol.gen.generator;

import org.eclipse.emf.common.util.URI;
import org.franca.deploymodel.dsl.FDeployPersistenceManager;
import org.franca.deploymodel.dsl.fDeploy.FDModel;

public abstract class AbstractProtocolGenerator {
	
	
	public String fdeplFileName; 
	public String outputFolder;
	
	public FDeployPersistenceManager fdeployLoader;
	
	public FDModel fdmodel;
	
	public AbstractProtocolGenerator(String fdeplFile, String outFolder) {
		this.fdeplFileName = fdeplFile;
		this.outputFolder = outFolder;
		
		FDeployInjectorProvider fDeployInjectorProvider = new FDeployInjectorProvider();
		fdeployLoader = fDeployInjectorProvider.getInjector().getInstance( FDeployPersistenceManager.class);
		URI root = URI.createURI("classpath:/");
		// TODO deal with various way to specify the URI  (relative path, absolute path, uri, ...)
		URI loc;
		if(fdeplFile.startsWith(".")) {
			loc = URI.createURI(this.fdeplFileName);
		} else {
			loc = URI.createFileURI(this.fdeplFileName);	
		}
		fdmodel = this.fdeployLoader.loadModel(loc, root);
	}
	
	abstract public void generate();
}
