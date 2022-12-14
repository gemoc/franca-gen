package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import org.franca.core.franca.FAnnotationBlock
import org.franca.core.franca.FTypeRef
import org.franca.core.franca.FTypedElement
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.franca.core.dsl.FrancaNameProvider

class FrancaJavaGenHelper {
	
	static Logger logger = LoggerFactory.getLogger(FrancaJavaGenHelper)
	
	static FrancaNameProvider nameProvider = new FrancaNameProvider
	
	static def String generateTypedElementString(FTypedElement typedElement, HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap, HashSet<String> importString) {
		if (typedElement.array) {
			//importString.add("java.util.List")
			'''«generateComment(typedElement.comment)»
«FrancaJavaGenHelper.generateTypeRefString(typedElement.type, generatedFileMap, importString)»[] «typedElement.name»;'''
		} else {
			'''«generateComment(typedElement.comment)»
«FrancaJavaGenHelper.generateTypeRefString(typedElement.type, generatedFileMap, importString)» «typedElement.name»;'''
		}
	}
	
	static def String generateTypeRefString(FTypeRef ftypeRef, HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap, HashSet<String> importString) {

		if (ftypeRef.derived !== null) {
			val derivedTypeFQN = FrancaHelper.getQName(ftypeRef.derived) 
			if( generatedFileMap.get(derivedTypeFQN) !== null) {
				importString.add( '''«generatedFileMap.get(derivedTypeFQN).javaFullName»''')
				'''«ftypeRef.derived.name»'''
			} else {
				logger.warn('''generateTypeRefString not implemented yet for «ftypeRef» / «derivedTypeFQN»''')
				''' /* Not implemented yet for «ftypeRef.predefined» */'''
			}
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