package hu.bzolt.webdsl.component

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.request.RequestGenerator
import hu.bzolt.webdsl.webDsl.Component
import org.eclipse.xtext.generator.IFileSystemAccess

class ComponentGenerator
{
	@Inject
	extension InferrerHelper

	@Inject
	extension RequestGenerator

	def generate(Component c, IFileSystemAccess fsa)
	{
		if (!c.requests.isEmpty) {
			fsa.generateFile(c.serviceFile, c.compile);
		}
	}

	def compile(Component c)
	'''
		app.service("«c.name»Service", ["$http", 
			function($http) {
				«FOR r : c.requests»
					
					«r.compile»
				«ENDFOR»		
		} ]);
	'''
}
