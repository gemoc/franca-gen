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
import org.franca.core.franca.FMethod
import org.gemoc.franca.protocol.lib.spec.RPCSpec
import org.gemoc.franca.protocol.lib.spec.RPCSpec.Enums.CallType

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
		val s = generateString(fdi)
		'''package «getPackageName(fdi)»;
«FOR element : importStringMap.get(fdi)»
import «element»;
«ENDFOR»
«s»
'''
	}
	
	override String getFileName(FDeployedInterface fdi){
		val fileName = '''«baseFileName»/«getPackageName(fdi).replaceAll("\\.","/")»/I«fdi.FInterface.name.toFirstUpper.replaceAll("\\.","/")».java''' 
		fileName
	}
	
	def String getPackageName(FDeployedInterface fdi) {
		//fdi.
		val fd = fdi.getFDElement(fdi.FInterface)
		'''«fd.getContainerOfType(FDModel).name.toLowerCase»'''
	}
	
	private def String generateString(FDeployedInterface fdi) {
		
		'''public interface I«fdi.FInterface.name.toFirstUpper» {
	«FOR method : fdi.FInterface.methods»
		«generateMethodString(method, fdi)»	
	«ENDFOR»
}'''
	}
	
	
	private def String generateMethodString(FMethod method, FDeployedInterface fdi) {
		var RPCSpec.InterfacePropertyAccessor ia = new RPCSpec.InterfacePropertyAccessor(fdi);
		if(ia.getCallType(method).equals(CallType.notification)) {
			addImport(fdi, "org.eclipse.lsp4j.jsonrpc.services.JsonNotification")
		}
		'''«IF ia.getCallType(method).equals(CallType.notification)»
@JsonNotification			
«ENDIF»default void «method.name»(){
	throw new UnsupportedOperationException();
}'''		
	}
	
	protected def addImport(FDeployedInterface ftype, String importString) {
		var importList = importStringMap.get(ftype)
		if (importList === null) {
			importStringMap.put(ftype, newHashSet)
			importList = importStringMap.get(ftype)
		}
		importList.add(importString)
	}
	
}