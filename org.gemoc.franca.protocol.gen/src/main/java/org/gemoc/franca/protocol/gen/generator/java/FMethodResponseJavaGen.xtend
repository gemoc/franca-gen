package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.franca.core.franca.FMethod
import org.franca.core.franca.FModel
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import static extension org.eclipse.xtext.EcoreUtil2.*

class FMethodResponseJavaGen extends AbstractJavaFileGenerator<FMethod> {

	static Logger logger = LoggerFactory.getLogger(FMethodResponseJavaGen)

	enum PackageNameStrategy {
		fixed,
		idl
	}

	public PackageNameStrategy packageNameStrategy = PackageNameStrategy.idl
	public String fixedPackageName = ""

	
	new(String baseFileName, FMethod fmethod, HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, fmethod, generatedFileMap)
	}

	new(String baseFileName, String packageName, FMethod fmethod, HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, fmethod, generatedFileMap)
		this.packageNameStrategy = PackageNameStrategy.fixed
		this.fixedPackageName = packageName
	}

	override void computeIndirectlyGeneratedFiles() {}

	override void generateFileContentString() {
		
		val s = generateString(baseModelElement)
		this.fileContentString = '''package «getPackageName(baseModelElement)»;
«FOR element : importString.sort»
import «element»;
«ENDFOR»
«s»
'''
		logger.debug(this.fileContentString)
		
	}

	override String getFileName() {
		val fileName = '''«baseFileName»/«getPackageName(baseModelElement).replaceAll("\\.","/")»/«baseModelElement.name.toFirstUpper»Response.java'''
		fileName
	}
	override String getJavaFullName() {
		'''«getPackageName(baseModelElement)».«baseModelElement.name.toFirstUpper»Response'''
		
	}

	def String getPackageName(FMethod fmethod) {
		switch (packageNameStrategy) {
			case PackageNameStrategy.fixed: {
				return this.fixedPackageName
			}
			case PackageNameStrategy.idl: {
				return '''«fmethod.getContainerOfType(FModel).name.toLowerCase».dto'''
			}
			default: {
			}
		}
	}
	
	private def String generateString(FMethod method){
		addImport( "org.eclipse.lsp4j.generator.JsonRpcData")
		'''@JsonRpcData
		public class «method.name.toFirstUpper»Response {
			«FOR inArg : baseModelElement.inArgs»
				«FrancaJavaGenHelper.generateTypedElementString(inArg, generatedFileMap, importString)»		
		«	ENDFOR»
		}'''
	}


}
