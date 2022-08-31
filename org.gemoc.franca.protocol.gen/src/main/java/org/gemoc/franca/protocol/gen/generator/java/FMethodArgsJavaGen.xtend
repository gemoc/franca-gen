package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import org.franca.core.franca.FCompoundType
import org.franca.core.franca.FField
import org.franca.core.franca.FModel
import org.franca.core.franca.FStructType
import org.franca.core.franca.FType
import org.franca.core.franca.FTypeCollection
import org.franca.core.franca.FTypeRef
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.franca.core.franca.FMethod

class FMethodArgsJavaGen extends AbstractJavaFileGenerator<FMethod> {

	static Logger logger = LoggerFactory.getLogger(FMethodArgsJavaGen)

	enum PackageNameStrategy {
		fixed,
		idl
	}

	public PackageNameStrategy packageNameStrategy = PackageNameStrategy.idl
	public String fixedPackageName = ""

	
	new(String baseFileName, FMethod fmethod, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, fmethod, generatedFileMap)
	}

	new(String baseFileName, String packageName, FMethod fmethod, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, fmethod, generatedFileMap)
		this.packageNameStrategy = PackageNameStrategy.fixed
		this.fixedPackageName = packageName
	}

	override void generateFileContentString() {
		
		
		this.fileContentString = '''package «getPackageName(baseModelElement)»;
public class «baseModelElement.name.toFirstUpper»Args {}'''
		logger.debug(this.fileContentString)
	}

	override String getFileName() {
		val fileName = '''«baseFileName»/«getPackageName(baseModelElement).replaceAll("\\.","/")»/«baseModelElement.name.toFirstUpper»Args.java'''
		fileName
	}
	override String getJavaFullName() {
		'''«getPackageName(baseModelElement)».«baseModelElement.name.toFirstUpper»Args'''
		
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

}
