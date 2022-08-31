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
import java.util.HashMap
import org.franca.core.franca.FModelElement
import org.eclipse.emf.ecore.EObject

class ProtocolGenerator4Java extends AbstractProtocolGenerator {
	
	static Logger logger = LoggerFactory.getLogger(ProtocolGenerator4Java)
	
	new(String fdeplFile, String outFolder) {
		super(fdeplFile, outFolder)
	}
	
	public HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap = newHashMap

	override void generate() {
		// generate types DTO
		var ResourceSet rs = this.fdmodel.eResource().getResourceSet()
		
		logger.info('''Generating Deployed API «this.fdmodel.getName()»''')
		
		// phase 1, compute list of generated file 
		val List<FType> fTypes = rs.allContents.filter(FType).toList
		fTypes.forEach[ ft |
			val FTypeDtoJavaGen typeDtoJavaGen = new FTypeDtoJavaGen(outputFolder, ft, generatedFileMap)
			generatedFileMap.put(ft, typeDtoJavaGen)
		]
		
		var FDModelExtender fdmodelExt = new FDModelExtender(fdmodel)
		var List<FDInterface> interfaces = fdmodelExt.getFDInterfaces()
		
		for (FDInterface fdInterface : interfaces) {
			val FDInterfaceJavaGen fdiJavaGen = new FDInterfaceJavaGen(outputFolder, fdInterface, generatedFileMap)	
			generatedFileMap.put(fdInterface, fdiJavaGen)
		} 
		// recursive call until no more generator are added ?
		var addedGenerator = true
		logger.debug('''«generatedFileMap.values.size» direct files to generated''')
		while (addedGenerator) {
			val nbBefore = generatedFileMap.values.size
			for (generator : generatedFileMap.values.clone) {
				generator.computeIndirectlyGeneratedFiles()
			}
			if(generatedFileMap.values.size == nbBefore) addedGenerator = false
			else {
				logger.debug('''Added «generatedFileMap.values.size - nbBefore» indirect files to generate''')
			}
		}
		
		// Phase 2, generate content and serialize
		logger.info('''Serializing «generatedFileMap.values.size» files...''')
		for (generator : generatedFileMap.values) {
			logger.debug('''Generating content of «generator.getFileName()»...''')
			generator.generateFileContentString()
			generator.serializeFile()
		}
		
	}

	def void printContent(FDModel fdmodel) {
		System.out.println(FrancaHelper.simpleContentString(fdmodel))
	}
}
