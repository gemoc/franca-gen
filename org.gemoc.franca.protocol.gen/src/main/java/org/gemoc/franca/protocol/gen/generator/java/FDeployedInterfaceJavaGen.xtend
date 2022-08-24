package org.gemoc.franca.protocol.gen.generator.java

import org.franca.deploymodel.core.FDeployedInterface
import org.apache.commons.io.FileUtils
import org.gemoc.franca.protocol.gen.generator.AbstractFileGenerator


import static extension org.eclipse.xtext.EcoreUtil2.*

import org.franca.core.franca.FModel
import org.franca.core.franca.FTypeCollection
import org.franca.deploymodel.dsl.fDeploy.FDModel
import java.util.HashSet
import java.util.HashMap

class FDeployedInterfaceJavaGen extends AbstractFileGenerator<FDeployedInterface>{
	
	HashMap<FDeployedInterface, HashSet<String>> importStringMap = newHashMap
	
	new(String baseFileName){
		super(baseFileName)
	}
	
	override String generateFileContentString(FDeployedInterface fdi){
		var importList = importStringMap.get(fdi)
		if (importList === null) {
			importStringMap.put(fdi, newHashSet)
		}
		val s = "// TODO" //generateString(fdi)
		'''package «getPackageName(fdi)»;
«FOR element : importStringMap.get(fdi)»
import «element»;
«ENDFOR»
«s»
'''
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