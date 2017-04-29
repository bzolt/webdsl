package hu.bzolt.webdsl.requestgroup

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.request.RequestGenerator
import hu.bzolt.webdsl.webDsl.RequestGroup
import org.eclipse.xtext.generator.IFileSystemAccess

class RequestGroupGenerator
{
	@Inject
	extension InferrerHelper

	@Inject
	extension RequestGenerator

	def generate(RequestGroup rg, IFileSystemAccess fsa)
	{
		fsa.generateFile(rg.serviceFile, rg.compile);
	}

	def compile(RequestGroup rg)
	'''
		app.service("«rg.name»Service", ["$http", 
			function($http) {
				«FOR r : rg.requests»
					
					«r.compile»
				«ENDFOR»		
		} ]);
	'''
}
