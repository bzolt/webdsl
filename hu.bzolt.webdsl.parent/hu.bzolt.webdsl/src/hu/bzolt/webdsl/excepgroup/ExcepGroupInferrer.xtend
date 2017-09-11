package hu.bzolt.webdsl.excepgroup

import com.google.inject.Inject
import hu.bzolt.webdsl.excep.ExcepInferrer
import hu.bzolt.webdsl.jvmmodel.AnnotationRefHelper
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.ExcepGroup
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmAnnotationReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypeReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

class ExcepGroupInferrer
{
	extension JvmAnnotationReferenceBuilder _annotationTypesBuilder;
	extension JvmTypeReferenceBuilder _typeReferenceBuilder;

	@Inject
	extension JvmTypesBuilder

	@Inject
	extension AnnotationRefHelper

	@Inject
	extension InferrerHelper

	@Inject
	ExcepInferrer excepInferrer

	def infer(ExcepGroup eg, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase,
		JvmAnnotationReferenceBuilder annotationTypesBuilder,
		JvmTypeReferenceBuilder typeReferenceBuilder)
		{
			this._annotationTypesBuilder = annotationTypesBuilder;
			this._typeReferenceBuilder = typeReferenceBuilder;
			for (e : eg.exceps)
			{
				excepInferrer.infer(e, acceptor, isPreIndexingPhase, _annotationTypesBuilder,
					_typeReferenceBuilder)
			}

			val handler = eg.toClass(eg.handlerName, [
				annotations += annotationRef(ControllerAdvice)

				val responseEntity = typeRef(ResponseEntity, typeRef(Void))
				for (e : eg.exceps)
				{
					members += e.toMethod(e.methodName, responseEntity) [
						annotations += annotationRef(ResponseBody)
						annotations +=
							annotationRef(ExceptionHandler).classValue(typeRef(e.className))
						body = '''return new «responseEntity»(«HttpStatus».valueOf(«e.code»));	'''
					]
				}
			])
			acceptor.accept(handler)
		}
	}
	