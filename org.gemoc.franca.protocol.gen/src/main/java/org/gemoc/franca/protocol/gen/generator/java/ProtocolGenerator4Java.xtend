package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.ResourceSet
import org.franca.core.franca.FType
import org.franca.deploymodel.core.FDModelExtender
import org.franca.deploymodel.dsl.fDeploy.FDInterface
import org.franca.deploymodel.dsl.fDeploy.FDModel
import org.gemoc.franca.protocol.gen.generator.AbstractProtocolGenerator
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.SimpleNameProvider
import org.franca.core.dsl.FrancaNameProvider

class ProtocolGenerator4Java extends AbstractProtocolGenerator {
	
	static Logger logger = LoggerFactory.getLogger(ProtocolGenerator4Java)
	
	new(String fdeplFile, String outFolder) {
		super(fdeplFile, outFolder)
	}
	
	public HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap = newHashMap
	
	FrancaNameProvider nameProvider = new FrancaNameProvider

	override void generate() {
		// generate types DTO
		var ResourceSet rs = this.fdmodel.eResource().getResourceSet()
		
		logger.info('''Generating Deployed API «this.fdmodel.getName()»''')
		
		// phase 1, compute list of generated file 
		val List<FType> fTypes = rs.allContents.filter(FType).toList
		fTypes.forEach[ ft |
			val FTypeDtoJavaGen typeDtoJavaGen = new FTypeDtoJavaGen(outputFolder, ft, generatedFileMap)
			generatedFileMap.put(FrancaHelper.getQName(ft), typeDtoJavaGen)
		]
		
		var FDModelExtender fdmodelExt = new FDModelExtender(fdmodel)
		var List<FDInterface> interfaces = fdmodelExt.getFDInterfaces()
		
		for (FDInterface fdInterface : interfaces) {
			val FDInterfaceJavaGen fdiJavaGen = new FDInterfaceJavaGen(outputFolder, fdInterface, generatedFileMap)
			logger.debug(FrancaHelper.getQName(fdInterface.target))	
			generatedFileMap.put(FrancaHelper.getQName(fdInterface.target), fdiJavaGen)
		} 
		// recursive call until no more generator are added ?
		var addedGenerator = true
		logger.debug('''«generatedFileMap.values.size» direct files to generate''')
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
		logger.debug('''Generated file list:
		    «generatedFileMap.keySet.map[it.toString].join("\n")»''')
		
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
