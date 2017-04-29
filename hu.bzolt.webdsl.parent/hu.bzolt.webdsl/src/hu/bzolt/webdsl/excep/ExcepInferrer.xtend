package hu.bzolt.webdsl.excep

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Excep
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmAnnotationReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypeReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

class ExcepInferrer
{
	extension JvmAnnotationReferenceBuilder _annotationTypesBuilder;
	extension JvmTypeReferenceBuilder _typeReferenceBuilder;

	@Inject
	extension JvmTypesBuilder

	@Inject
	extension InferrerHelper

	def infer(Excep e, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase,
		JvmAnnotationReferenceBuilder annotationTypesBuilder,
		JvmTypeReferenceBuilder typeReferenceBuilder)
		{
			this._annotationTypesBuilder = annotationTypesBuilder;
			this._typeReferenceBuilder = typeReferenceBuilder;

			val exceptionClass = e.toClass(e.className)
			acceptor.accept(exceptionClass) [
				superTypes += typeRef(RuntimeException)

				members += e.toConstructor [
					parameters += e.toParameter("message", typeRef(String))

					body = '''super(message);'''
				]

			]
		}
	}
	