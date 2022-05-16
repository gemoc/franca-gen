package fr.inria.diverse.francaTest.gen

import org.franca.core.franca.FInterface

import org.franca.deploymodel.core.FDeployedInterface
import org.franca.deploymodel.ext.providers.FDeployedProvider
import org.franca.deploymodel.dsl.fDeploy.FDExtensionRoot
import fr.inria.diverse.francaTest.RPCSpec.InterfacePropertyAccessor
import org.franca.core.franca.FMethod
import org.franca.core.franca.FTypeRef
import org.franca.core.franca.FBasicTypeId
import org.franca.core.franca.FType
import org.franca.core.franca.FTypeCollection
import java.util.List
import org.franca.core.franca.FStructType
import org.franca.core.franca.FField

class JrpcDtoGen {
		def generateDtoClass (List<FTypeCollection> typeCollections,String basePackageName) {
		generateData(typeCollections,basePackageName)	
	} 
	

	def private generateData (List<FTypeCollection> typeCollections,String basePackageName)'''
		«generateHeader(basePackageName)»
			«FOR typeCollection : typeCollections»
				«typeCollection.generate»		 
			«ENDFOR»
			
		}
	'''
	
	def private generate(FTypeCollection collection)'''
		«FOR type : collection.types»
			«type.generate»
			
		«ENDFOR»
		
	'''
	
	def private dispatch generate(FType type){
		throw new Exception("You should not pass there ! You need to handle the missing concrete type")
	}
	
	def private dispatch generate(FStructType type)'''
		class «type.name» {
			«FOR element : type.elements»
				«element.type.generate()» «element.name»
			«ENDFOR»
		}
	'''
	
	def private generate (FTypeRef it) {
		if(derived!=null){
			derived.name
		}else{
			switch(predefined){
				case FBasicTypeId::STRING : "String"
				case FBasicTypeId::BOOLEAN: "Boolean"
				default                   : "/*" + predefined.toString + "*/"  // TODO
			}
		}
	}
	
	
	def private generateHeader ( String basePackageName) '''
		/*---------------------------------------------------------------------------------------------
		 * Copyright (c) 2020 Inria and others.
		 * All rights reserved. This program and the accompanying materials
		 * are made available under the terms of the Eclipse Public License v1.0
		 * which accompanies this distribution, and is available at
		 * http://www.eclipse.org/legal/epl-v10.html
		 *--------------------------------------------------------------------------------------------*/
		/* GENERATED FILE, DO NOT MODIFY MANUALLY */
		
		package «basePackageName».data;
		
		import java.util.Map
		import org.eclipse.lsp4j.generator.JsonRpcData
		import org.eclipse.lsp4j.jsonrpc.messages.Either
		import org.eclipse.lsp4j.jsonrpc.validation.NonNull
		/** Declaration of data classes and enum for the EngineAddonProtocolData.
			Auto-generated from json schema. Do not edit manually.
		*/
	'''
	
	
	
	
	
	
}
