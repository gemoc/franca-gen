package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashMap
import java.util.HashSet
import org.gemoc.franca.protocol.gen.generator.AbstractFileGenerator

abstract class AbstractJavaFileGenerator<T> extends AbstractFileGenerator<T> {
	
	protected HashSet<String> importString = newHashSet
	
	public HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap
	
	
	new(String baseFileName, T baseModelElement, HashMap<String, AbstractJavaFileGenerator<?>> generatedFileMap) {
		super(baseFileName, baseModelElement)
		this.generatedFileMap = generatedFileMap
	}
	
	protected def addImport(String importString) {
		this.importString.add(importString)
	}
	
	/** The goal of this method is to make sure to create all AbstractJavaFileGenerator in generatedFileMap before calling the generate content  */
	def void computeIndirectlyGeneratedFiles()
	
	def String getJavaFullName()
	
}