package org.gemoc.franca.protocol.gen.generator.java

import org.eclipse.emf.ecore.EObject
import org.franca.deploymodel.dsl.fDeploy.FDModel
import org.franca.deploymodel.dsl.fDeploy.FDSpecification
import org.franca.deploymodel.core.FDeployedRootElement
import org.franca.core.franca.FTypeCollection

class FrancaHelper {
	
	
	def static simpleContentString(EObject obj) {
		obj.toString
	}
	def static simpleContentString(FDModel fdmodel) {
		'''FDModel «fdmodel.name» {
		''' +
		'''«FOR element : fdmodel.specifications»
		«element.simpleContentString»	
		«ENDFOR»''' +
		'''«FOR element : fdmodel.deployments»
		«element.simpleContentString»	
		«ENDFOR»'''+
		'''}'''	
	}
	
	def static simpleContentString(FDSpecification obj) {
		'''FDSpecification «obj.name»'''
	}
	
	def static simpleContentString(FDeployedRootElement obj) {
		'''FDeployedRootElement «obj.toString»'''
	}
	
	
}