package org.gemoc.franca.protocol.gen.generator

import org.franca.core.franca.FInterface


import org.franca.core.franca.FMethod
import org.franca.core.franca.FTypeRef
import org.franca.core.franca.FBasicTypeId
import org.gemoc.franca.protocol.lib.spec.RPCSpec.InterfacePropertyAccessor
import org.franca.deploymodel.core.FDeployedInterface

class JrpcInterfaceGen {
	InterfacePropertyAccessor deploy
		def generateInterface (FDeployedInterface deployed, String basePackageName) {
		deploy = new InterfacePropertyAccessor(deployed)
		generateInterface(deployed.FInterface, basePackageName)	
	} 
	

	def private generateInterface (FInterface api, String basePackageName)'''
		«api.generateHeader(basePackageName)»
		public interface «api.name» {
			«FOR m : api.methods»
				«m.generateMethodDeclaration»		 
			«ENDFOR»
			
		}
	'''
	
	
	
	def private generateHeader (FInterface api, String basePackageName) '''
		/*---------------------------------------------------------------------------------------------
		 * Copyright (c) 2020 Inria and others.
		 * All rights reserved. This program and the accompanying materials
		 * are made available under the terms of the Eclipse Public License v1.0
		 * which accompanies this distribution, and is available at
		 * http://www.eclipse.org/legal/epl-v10.html
		 *--------------------------------------------------------------------------------------------*/
		/* GENERATED FILE, DO NOT MODIFY MANUALLY */
		
		package «basePackageName».services;
		
		import com.google.gson.annotations.SerializedName;
		import java.util.concurrent.CompletableFuture;
		import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;
		import «basePackageName».data.*;
		/** Server interface for the model execution trace protocol.
			Auto-generated from Franca declaration. Do not edit manually.
		*/
	'''
	
	def private generateMethodDeclaration(FMethod method)'''
		«deploy.getIsNotification(method)?"@JsonNotification":"@JsonRequest"»
		default «method.outArgs.isNullOrEmpty?"void":method.outArgs.get(0)?.type.generate» CompletableFuture<«FOR attr : method.inArgs»«attr.type.generate» «attr.name»«ENDFOR»>
		
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
	
	
	
}