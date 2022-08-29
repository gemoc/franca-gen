package org.gemoc.franca.protocol.gen.generator.java

import java.util.HashSet
import org.gemoc.franca.protocol.gen.generator.AbstractFileGenerator

abstract class AbstractJavaFileGenerator<T> extends AbstractFileGenerator<T> {
	
	protected HashSet<String> importString = newHashSet
	
	new(String baseFileName, T baseModelElement) {
		super(baseFileName, baseModelElement)
	}
	
	protected def addImport(String importString) {
		this.importString.add(importString)
	}
	
}