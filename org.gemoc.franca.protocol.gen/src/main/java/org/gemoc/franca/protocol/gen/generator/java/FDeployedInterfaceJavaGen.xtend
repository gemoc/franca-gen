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

class FDeployedInterfaceJavaGen extends AbstractJavaFileGenerator<FDeployedInterface>{
	
	RPCSpec.InterfacePropertyAccessor ipAccessor
	
	//HashMap<FDeployedInterface, HashSet<String>> importStringMap = newHashMap
	
	new(String baseFileName, FDeployedInterface fdi){
		super(baseFileName, fdi)
		ipAccessor = new RPCSpec.InterfacePropertyAccessor(fdi);
	}
	
	override String generateFileContentString(){
		val s = generateString()
		'''package «getPackageName()»;
«FOR element : this.importString»
import «element»;
«ENDFOR»
«s»
'''
	}
	
	override String getFileName(){
		val fileName = '''«baseFileName»/«getPackageName().replaceAll("\\.","/")»/I«baseModelElement.FInterface.name.toFirstUpper.replaceAll("\\.","/")».java''' 
		fileName
	}
	
	def String getPackageName() {
		//fdi.
		val fd = baseModelElement.getFDElement(baseModelElement.FInterface)
		'''«fd.getContainerOfType(FDModel).name.toLowerCase»'''
	}
	
	private def String generateString() {
		
		'''public interface I«baseModelElement.FInterface.name.toFirstUpper» {
	«FOR method : baseModelElement.FInterface.methods»
		«generateMethodString(method)»	
	«ENDFOR»
}'''
	}
	
	
	private def String generateMethodString(FMethod method) {
		
		'''«generateMethodAnnotationString(method)»			
default void «method.name»(){
	throw new UnsupportedOperationException();
}'''		
	}
	
	private def String generateMethodAnnotationString(FMethod method) {
		switch (ipAccessor.getCallType(method)) {
			case CallType.notification: {
				addImport("org.eclipse.lsp4j.jsonrpc.services.JsonNotification")
				'''@JsonNotification'''
			}
			default: {
				addImport("org.eclipse.lsp4j.jsonrpc.services.JsonRequest")
				'''@JsonRequest'''
			}
		}
	}
	

	
}