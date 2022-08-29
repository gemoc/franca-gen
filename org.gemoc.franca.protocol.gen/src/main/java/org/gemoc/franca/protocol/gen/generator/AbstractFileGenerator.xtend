package org.gemoc.franca.protocol.gen.generator

import org.apache.commons.io.FileUtils

abstract class AbstractFileGenerator<T> {
	
	public String baseFileName = ""
	
	public T baseModelElement
	
	new(String baseFileName, T baseModelElement){
		this.baseFileName = baseFileName
		this.baseModelElement = baseModelElement
	}
	
	def abstract String generateFileContentString()

	def String getFileName()

	def void serializeFile( String generatedtring){
		val fileName = getFileName() 
		FileUtils.getFile(fileName)
		FileUtils.writeStringToFile(FileUtils.getFile(fileName), generatedtring, "UTF-8")
	}
}
