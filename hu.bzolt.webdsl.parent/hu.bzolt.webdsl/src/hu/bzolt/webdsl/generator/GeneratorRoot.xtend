package hu.bzolt.webdsl.generator

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

class GeneratorRoot implements IGenerator
{
	@Inject
	SpringJvmModelGenerator springJvmModelGenerator

	@Inject
	WebDslGenerator webDslGenerator

	override doGenerate(Resource input, IFileSystemAccess fsa)
	{
		springJvmModelGenerator.doGenerate(input, fsa)
		webDslGenerator.doGenerate(input, fsa)
	}

}
