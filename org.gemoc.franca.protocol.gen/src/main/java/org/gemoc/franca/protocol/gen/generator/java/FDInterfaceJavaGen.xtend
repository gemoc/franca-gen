package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.franca.core.franca.FMethod
import org.franca.deploymodel.core.FDeployedInterface
import org.franca.deploymodel.dsl.fDeploy.FDModel
import org.gemoc.franca.protocol.lib.spec.RPCSpec
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.franca.deploymodel.dsl.fDeploy.FDInterface

class FDInterfaceJavaGen extends AbstractJavaFileGenerator<FDInterface> {
	static Logger logger = LoggerFactory.getLogger(FDInterfaceJavaGen)
	
	FDeployedInterface deployedInterface
	RPCSpec.InterfacePropertyAccessor ipAccessor

	// HashMap<FDeployedInterface, HashSet<String>> importStringMap = newHashMap
	new(String baseFileName, FDInterface fdi, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, fdi, generatedFileMap)
		this.deployedInterface = new FDeployedInterface(fdi)
		ipAccessor = new RPCSpec.InterfacePropertyAccessor(deployedInterface);
	}
	
	override void computeIndirectlyGeneratedFiles() {
		for (method : deployedInterface.FInterface.methods) {
			if(method.inArgs.size != 0) {
				switch (ipAccessor.getArgsType(method)) {
					case dedicatedClass: {
						val argGenerator = new FMethodArgsJavaGen(this.baseFileName, method, generatedFileMap)
						this.generatedFileMap.put(method, argGenerator)
					}
					case optimized: {
						if (method.inArgs.size != 1) {
							val argGenerator = new FMethodArgsJavaGen(this.baseFileName, method, generatedFileMap)
							this.generatedFileMap.put(method, argGenerator)
						}
					}
					default: {
					}
				}
			}
		}
	}
	
	override void generateFileContentString() {
		val s = generateString()
		this.fileContentString = '''package «getPackageName()»;
«FOR element : this.importString»
import «element»;
«ENDFOR»
«s»
'''
		logger.debug(this.fileContentString)
	}

	override String getFileName() {
		val fileName = '''«baseFileName»/«getPackageName().replaceAll("\\.","/")»/I«deployedInterface.FInterface.name.toFirstUpper.replaceAll("\\.","/")».java'''
		fileName
	}
	
	override String getJavaFullName() {
		'''«getPackageName()».I«deployedInterface.FInterface.name.toFirstUpper»'''
	}

	def String getPackageName() {
		// fdi.
		val fd = deployedInterface.getFDElement(deployedInterface.FInterface)
		'''«fd.getContainerOfType(FDModel).name.toLowerCase»'''
	}

	private def String generateString() {

	'''public interface I«deployedInterface.FInterface.name.toFirstUpper» {
	«FOR method : deployedInterface.FInterface.methods»
		«generateMethodString(method)»	
	«ENDFOR»
}'''
	}

	private def String generateMethodString(FMethod method) {

		'''«generateMethodAnnotationString(method)»			
default «generateMethodReturnTypeString(method)» «method.name»(«generateMethodParameterString(method)»){
	throw new UnsupportedOperationException();
}'''
	}

	private def String generateMethodAnnotationString(FMethod method) {
		if (method.isFireAndForget) {
			addImport("org.eclipse.lsp4j.jsonrpc.services.JsonNotification")
			'''@JsonNotification'''
		} else {
			addImport("org.eclipse.lsp4j.jsonrpc.services.JsonRequest")
			'''@JsonRequest'''
		}
	}

	private def String generateMethodReturnTypeString(FMethod method) {

		if (method.isFireAndForget) {
			'''void'''
		} else {
			if (method.outArgs.empty) {
				addImport("java.util.concurrent.CompletableFuture")
				'''CompletableFuture<Void>'''
			} else {
				'''/* TODO */ void'''
			}
		}
	}

	private def String generateMethodParameterString(FMethod method) {
		if(method.inArgs.size == 0) return ""
		switch (ipAccessor.getArgsType(method)) {
			case dedicatedClass: {
				val argGenerator = this.generatedFileMap.get(method)
				addImport('''«argGenerator.javaFullName»''')
				'''«method.name.toFirstUpper»Args args'''
			}
			case optimized: {
				if (method.inArgs.size == 1) {
					'''«method.inArgs.get(0).type» «method.inArgs.get(0).name»'''
				} else {
					val argGenerator = this.generatedFileMap.get(method)
					addImport('''«argGenerator.javaFullName»''')
					'''«method.name.toFirstUpper»Args args'''
				}
			}
			default: {
				'''/* TODO */ void'''
			}
		}
	}

}
