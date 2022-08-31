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

class FTypeDtoJavaGen extends AbstractJavaFileGenerator<FType> {

	static Logger logger = LoggerFactory.getLogger(FTypeDtoJavaGen)

	enum PackageNameStrategy {
		fixed,
		idl
	}

	public PackageNameStrategy packageNameStrategy = PackageNameStrategy.idl
	public String fixedPackageName = ""

	
	new(String baseFileName, FType ftype, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, ftype, generatedFileMap)
	}

	new(String baseFileName, String packageName, FType ftype, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, ftype, generatedFileMap)
		this.packageNameStrategy = PackageNameStrategy.fixed
		this.fixedPackageName = packageName
	}

	override void generateFileContentString() {
		
		val s = generateString(baseModelElement)
		this.fileContentString = '''package «getPackageName(baseModelElement)»;
«FOR element : importString»
import «element»;
«ENDFOR»
«s»
'''
		logger.debug(this.fileContentString)
	}

	override void computeIndirectlyGeneratedFiles() {
		
	}

	override String getFileName() {
		val fileName = '''«baseFileName»/«getPackageName(baseModelElement).replaceAll("\\.","/")»/«baseModelElement.name.toFirstUpper».java'''
		fileName
	}
	
	override String getJavaFullName() {
		'''«getPackageName(baseModelElement)».«baseModelElement.name.toFirstUpper»'''		
	}

	private def dispatch String generateString(FType ftype) {
		'''// not implemented for «ftype.name» «ftype.class.name»'''
	}

	private def dispatch String generateString(FCompoundType fstructype) {
		addImport( "org.eclipse.lsp4j.generator.JsonRpcData")
		'''@JsonRpcData
public class «fstructype.name» {
	// «fstructype.class»	
}'''
	}

	private def dispatch String generateString(FStructType fstructype) {
		addImport( "org.eclipse.lsp4j.generator.JsonRpcData")
		'''@JsonRpcData
class «fstructype.name» «IF fstructype.base !== null» extends «fstructype.base.name»«ENDIF»{
	// «fstructype.class»	
	«FOR field : fstructype.elements»
	«generateFieldString(field, fstructype)»	
	«ENDFOR»
}'''
	}

	private def String generateFieldString(FField field, FType ftype) {
		field.type
		if (field.array) {
			addImport("java.util.List")
			'''List<«generateFieldTypeString(field.type, ftype)»> «field.name»;'''
		} else {
			'''«generateFieldTypeString(field.type, ftype)» «field.name»;'''
		}
	}

	private def String generateFieldTypeString(FTypeRef ftypeRef, FType ftype) {
		if (ftypeRef.derived !== null) {
			addImport( '''«getPackageName(ftypeRef.derived)».«ftypeRef.derived.name»''')
			'''«ftypeRef.derived.name»'''
		} else if (ftypeRef.predefined !== null) {
			switch (ftypeRef.predefined) {
				case BOOLEAN: {
					'''Boolean'''
				}
				case STRING: {
					'''String'''
				}
				default: {
					logger.warn('''generateFieldTypeString not implemented yet for «ftypeRef»''')
					''' /* Not implemented yet for «ftypeRef.predefined» */'''
				}
			}
		} else
			'''Object'''
	}

	def String getPackageName(FType ftype) {
		switch (packageNameStrategy) {
			case PackageNameStrategy.fixed: {
				return this.fixedPackageName
			}
			case PackageNameStrategy.idl: {
				return '''«ftype.getContainerOfType(FModel).name.toLowerCase».«ftype.getContainerOfType(FTypeCollection).name.toLowerCase»'''
			}
			default: {
			}
		}
	}

}
