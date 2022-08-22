package org.gemoc.franca.protocol.gen.generator

import org.apache.commons.io.FileUtils

abstract class AbstractFileGenerator<T> {
	
	public String baseFileName = ""
	
	new(String baseFileName){
		this.baseFileName = baseFileName
	}
	
	def abstract String generateFileContentString(T t)

	def String getFileName(T t)

	def void serializeFile(T t, String generatedtring){
		val fileName = getFileName(t) 
		FileUtils.getFile(fileName)
		FileUtils.writeStringToFile(FileUtils.getFile(fileName), generatedtring, "UTF-8")
	}
}
