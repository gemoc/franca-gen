package org.gemoc.franca.protocol.gen.generator.java

import org.franca.deploymodel.core.FDeployedInterface
import org.apache.commons.io.FileUtils
import org.gemoc.franca.protocol.gen.generator.AbstractFileGenerator


import static extension org.eclipse.xtext.EcoreUtil2.*

import org.franca.core.franca.FModel
import org.franca.core.franca.FTypeCollection
import org.franca.deploymodel.dsl.fDeploy.FDModel

class FDeployedInterfaceJavaGen extends AbstractFileGenerator<FDeployedInterface>{
	
	new(String baseFileName){
		super(baseFileName)
	}
	
	override String generateFileContentString(FDeployedInterface fdi){
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override void serializeFile(FDeployedInterface fdi, String generatedtring){
		val fileName = getFileName(fdi) 
		FileUtils.getFile(fileName)
		FileUtils.writeStringToFile(FileUtils.getFile(fileName), generatedtring, "UTF-8")
	}
	override String getFileName(FDeployedInterface fdi){
		val fileName = '''«baseFileName»/«getPackageName(fdi).replaceAll("\\.","/")»/«fdi.FInterface.name.toFirstUpper.replaceAll("\\.","/")».java''' 
		fileName
	}
	
	def String getPackageName(FDeployedInterface fdi) {
		//fdi.
		val fd = fdi.getFDElement(fdi.FInterface)
		'''«fd.getContainerOfType(FDModel).name.toLowerCase»'''
	}
	
}