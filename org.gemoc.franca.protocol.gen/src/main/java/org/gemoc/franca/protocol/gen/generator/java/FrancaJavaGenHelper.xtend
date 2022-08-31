package org.gemoc.franca.protocol.gen.generator.java

import org.franca.core.franca.FTypeRef
import org.slf4j.LoggerFactory
import org.slf4j.Logger
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import java.util.HashSet
import org.franca.core.franca.FTypedElement
import org.franca.core.franca.FAnnotation
import org.franca.core.franca.FAnnotationBlock

class FrancaJavaGenHelper {
	
	static Logger logger = LoggerFactory.getLogger(FrancaJavaGenHelper)
	
	static def String generateTypedElementString(FTypedElement typedElement, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap, HashSet<String> importString) {
		if (typedElement.array) {
			importString.add("java.util.List")
			'''«generateComment(typedElement.comment)»
List<«FrancaJavaGenHelper.generateTypeRefString(typedElement.type, generatedFileMap, importString)»> «typedElement.name»;'''
		} else {
			'''«generateComment(typedElement.comment)»
«FrancaJavaGenHelper.generateTypeRefString(typedElement.type, generatedFileMap, importString)» «typedElement.name»;'''
		}
	}
	
	static def String generateTypeRefString(FTypeRef ftypeRef, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap, HashSet<String> importString) {
		if (ftypeRef.derived !== null && generatedFileMap.get(ftypeRef.derived) !== null) {
			importString.add( '''«generatedFileMap.get(ftypeRef.derived).javaFullName»''')
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
					logger.warn('''generateTypeRefString not implemented yet for «ftypeRef»''')
					''' /* Not implemented yet for «ftypeRef.predefined» */'''
				}
			}
		} else
			'''Object'''
	}
	
	static def String generateComment(FAnnotationBlock annot) {
		if(annot === null || annot.elements.empty) return ''''''
		'''/** «FOR element : annot.elements»
		  «element.type.getName.toFirstUpper»: «element.comment»
		  */«ENDFOR»'''
		
	}
}