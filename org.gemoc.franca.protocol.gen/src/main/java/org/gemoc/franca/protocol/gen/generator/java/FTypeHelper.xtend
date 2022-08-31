package org.gemoc.franca.protocol.gen.generator.java

import org.franca.core.franca.FTypeRef
import org.slf4j.LoggerFactory
import org.slf4j.Logger
import java.util.HashMap
import org.eclipse.emf.ecore.EObject
import java.util.HashSet

class FTypeHelper {
	
	static Logger logger = LoggerFactory.getLogger(FTypeHelper)
	
	def String generateFieldTypeString(FTypeRef ftypeRef, HashMap<EObject, AbstractJavaFileGenerator<?>> generatedFileMap, HashSet<String> importString) {
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
					logger.warn('''generateFieldTypeString not implemented yet for «ftypeRef»''')
					''' /* Not implemented yet for «ftypeRef.predefined» */'''
				}
			}
		} else
			'''Object'''
	}
}