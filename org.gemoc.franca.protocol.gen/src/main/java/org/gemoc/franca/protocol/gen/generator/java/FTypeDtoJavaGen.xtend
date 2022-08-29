package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import java.util.HashSet
import org.franca.core.franca.FCompoundType
import org.franca.core.franca.FField
import org.franca.core.franca.FModel
import org.franca.core.franca.FStructType
import org.franca.core.franca.FType
import org.franca.core.franca.FTypeCollection
import org.franca.core.franca.FTypeRef
import org.gemoc.franca.protocol.gen.generator.AbstractFileGenerator
import org.slf4j.Logger
import org.slf4j.LoggerFactory

import static extension org.eclipse.xtext.EcoreUtil2.*

class FTypeDtoJavaGen extends AbstractFileGenerator<FType> {

	static Logger logger = LoggerFactory.getLogger(FTypeDtoJavaGen)

	enum PackageNameStrategy {
		fixed,
		idl
	}

	public PackageNameStrategy packageNameStrategy = PackageNameStrategy.idl
	public String fixedPackageName = ""

	HashMap<FType, HashSet<String>> importStringMap = newHashMap

	new(String baseFileName, FType ftype) {
		super(baseFileName, ftype)
	}

	new(String baseFileName, String packageName, FType ftype) {
		super(baseFileName, ftype)
		this.packageNameStrategy = PackageNameStrategy.fixed
		this.fixedPackageName = packageName
	}

	override String generateFileContentString() {
		var importList = importStringMap.get(baseModelElement)
		if (importList === null) {
			importStringMap.put(baseModelElement, newHashSet)
		}
		val s = generateString(baseModelElement)
		'''package «getPackageName(baseModelElement)»;
«FOR element : importStringMap.get(baseModelElement)»
import «element»;
«ENDFOR»
«s»
'''
	}

	override String getFileName() {
		val fileName = '''«baseFileName»/«getPackageName(baseModelElement).replaceAll("\\.","/")»/«baseModelElement.name.toFirstUpper».java'''
		fileName
	}

	private def dispatch String generateString(FType ftype) {
		'''// not implemented for «ftype.name» «ftype.class.name»'''
	}

	private def dispatch String generateString(FCompoundType fstructype) {
		addImport(fstructype, "org.eclipse.lsp4j.generator.JsonRpcData")
		'''@JsonRpcData
class «fstructype.name» {
	// «fstructype.class»	
}'''
	}

	private def dispatch String generateString(FStructType fstructype) {
		addImport(fstructype, "org.eclipse.lsp4j.generator.JsonRpcData")
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
			addImport(ftype, "java.util.List")
			'''List<«generateFieldTypeString(field.type, ftype)»> «field.name»;'''
		} else {
			'''«generateFieldTypeString(field.type, ftype)» «field.name»;'''
		}
	}

	private def String generateFieldTypeString(FTypeRef ftypeRef, FType ftype) {
		if (ftypeRef.derived !== null) {
			addImport(ftype, '''«getPackageName(ftypeRef.derived)».«ftypeRef.derived.name»''')
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

	protected def addImport(FType ftype, String importString) {
		var importList = importStringMap.get(ftype)
		if (importList === null) {
			importStringMap.put(ftype, newHashSet)
			importList = importStringMap.get(ftype)
		}
		importList.add(importString)
	}
}
