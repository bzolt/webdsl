package hu.bzolt.webdsl.generator

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.xbase.compiler.DisableCodeGenerationAdapter
import org.eclipse.xtext.xbase.compiler.IGeneratorConfigProvider
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator

class SpringJvmModelGenerator extends JvmModelGenerator
{
	@Inject
	IGeneratorConfigProvider generatorConfigProvider

	override dispatch void internalDoGenerate(JvmDeclaredType type, IFileSystemAccess fsa)
	{
		if (DisableCodeGenerationAdapter.isDisabled(type))
			return;
		if (type.qualifiedName !== null)
			fsa.generateFile("main/java/" + type.qualifiedName.replace('.', '/') + '.java',
				type.generateType(generatorConfigProvider.get(type)))
	}
}
