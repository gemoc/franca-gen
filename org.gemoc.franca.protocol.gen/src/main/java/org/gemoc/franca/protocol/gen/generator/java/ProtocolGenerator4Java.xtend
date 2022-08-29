package org.gemoc.franca.protocol.gen.generator.java

import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.franca.core.franca.FModel
import org.franca.core.franca.FType
import org.franca.deploymodel.core.FDModelExtender
import org.franca.deploymodel.core.FDeployedInterface
import org.franca.deploymodel.dsl.fDeploy.FDInterface
import org.franca.deploymodel.dsl.fDeploy.FDModel
import org.gemoc.franca.protocol.gen.generator.AbstractProtocolGenerator
import org.slf4j.LoggerFactory
import org.slf4j.Logger

class ProtocolGenerator4Java extends AbstractProtocolGenerator {
	
	static Logger logger = LoggerFactory.getLogger(ProtocolGenerator4Java)
	
	new(String fdeplFile, String outFolder) {
		super(fdeplFile, outFolder)
	}

	override void generate() {
		// generate types DTO
		var ResourceSet rs = this.fdmodel.eResource().getResourceSet()
		
		logger.info('''Generating Deployed API «this.fdmodel.getName()»''')
		
		val List<FType> fTypes = rs.allContents.filter(FType).toList
		fTypes.forEach[ ft |
			val FTypeDtoJavaGen typeDtoJavaGen = new FTypeDtoJavaGen(outputFolder, ft)
			logger.info('''Generating «typeDtoJavaGen.getFileName()»...''')
			val content =  typeDtoJavaGen.generateFileContentString()
			logger.debug(typeDtoJavaGen.generateFileContentString())
			typeDtoJavaGen.serializeFile(content)
		]
		
		// generate Deployed Interfaces
		// generate Deployed Interfaces parameters DTO
		// get interfaces referenced by FDeploy model
		var FDModelExtender fdmodelExt = new FDModelExtender(fdmodel)
		var List<FDInterface> interfaces = fdmodelExt.getFDInterfaces()
		
		for (FDInterface fdInterface : interfaces) {
			
			var FDeployedInterface deployedInterface = new FDeployedInterface(fdInterface)
			val FDeployedInterfaceJavaGen fdiJavaGen = new FDeployedInterfaceJavaGen(outputFolder, deployedInterface)	
			logger.info('''Generating «fdiJavaGen.getFileName()»...''')
			val content =  fdiJavaGen.generateFileContentString()
			logger.debug(fdiJavaGen.generateFileContentString())
			fdiJavaGen.serializeFile(content)
		} 
	}

	def void printContent(FDModel fdmodel) {
		System.out.println(FrancaHelper.simpleContentString(fdmodel))
	}
}
