package hu.bzolt.webdsl.requestgroup

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.AnnotationRefHelper
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Method
import hu.bzolt.webdsl.webDsl.Request
import hu.bzolt.webdsl.webDsl.RequestGroup
import hu.bzolt.webdsl.webDsl.RequestParameter
import hu.bzolt.webdsl.webDsl.UrlSegment
import java.util.ArrayList
import java.util.Date
import java.util.List
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmAnnotationReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypeReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

class RequestGroupInferrer
{
	extension JvmAnnotationReferenceBuilder _annotationTypesBuilder;
	extension JvmTypeReferenceBuilder _typeReferenceBuilder;

	@Inject
	extension JvmTypesBuilder

	@Inject
	extension AnnotationRefHelper

	@Inject
	extension InferrerHelper

	def returnType(Request r)
	{
		return if (r.method == Method.GET)
			if (r.list)
				typeRef(List, typeRef(r.entity.className))
			else
				typeRef(r.entity.className)
		else
			typeRef(void)
	}

	def pathType(UrlSegment s)
	{
		return switch (s.constraint)
		{
			case DATE,
			case DATETIME,
			case TIME: typeRef(Date)
			case NUMBER: typeRef(int)
			case STRING: typeRef(String)
		}
	}

	def paramType(RequestParameter p)
	{
		return switch (p.type)
		{
			case DATE: typeRef(Date)
			case NUMBER: typeRef(Integer)
			case STRING: typeRef(String)
			case BOOLEAN: typeRef(Boolean)
		}
	}

	def responseEntityType(Request r)
	{
		return if (r.method == Method.GET)
			if (r.list)
				typeRef(List, typeRef(r.entity.className))
			else
				typeRef(r.entity.className)
		else
			typeRef(Void)
	}

	def toMapping(Method m)
	{
		return switch (m)
		{
			case GET: GetMapping
			case POST: PostMapping
		}
	}

	def typeAnnotation(UrlSegment s)
	{
//		val enumType = typeRef(ISO).type as JvmEnumerationType
		return switch (s.constraint)
		{
			case DATE:
			{
//				val literal = enumType.literals.findFirst[l|"DATE".equals(l.simpleName)]
//				annotationRef(DateTimeFormat).isoValue(literal)
				null
			}
			case DATETIME:
			{
//				val literal = enumType.literals.findFirst[l|"DATE_TIME".equals(l.simpleName)]
//				annotationRef(DateTimeFormat).isoValue(literal)
				null
			}
			case TIME:
			{
//				val literal = enumType.literals.findFirst[l|"TIME".equals(l.simpleName)]
//				annotationRef(DateTimeFormat).isoValue(literal)
				null
			}
			case NUMBER,
			case String:
			{
				null
			}
		}
	}

	def toParameters(Request r)
	{
		val parameters = new ArrayList<JvmFormalParameter>
		if (r.principal)
		{
			parameters += r.toParameter("userDetails", typeRef(UserDetails))
		}
		for (s : r.url.pathVariables)
		{
			parameters += s.toParameter(s.name, s.pathType)
		}
		for (p : r.url.parameters)
		{
			parameters += p.toParameter(p.name, p.paramType)
		}
		if (r.method == Method.POST)
		{
			parameters += r.toParameter(r.entity.name.toFirstLower, typeRef(r.entity.className))
		}
		else if (r.pageable)
		{
			parameters += r.toParameter("pageable", typeRef(Pageable))
		}
		return parameters
	}

	def toService(RequestGroup rg)
	{
		return rg.toInterface(rg.serviceName, [
			for (r : rg.requests)
			{
				members += r.toMethod(r.methodName, r.returnType ?: inferredType) [
					abstract = true
					parameters += r.toParameters
				]
			}
		])
	}

	def toRequestVariables(Request r)
	{
		val requestVariables = new ArrayList<JvmFormalParameter>
		if (r.principal)
		{
			var userDetails = r.toParameter("userDetails", typeRef(UserDetails))
			userDetails.annotations += annotationRef(AuthenticationPrincipal)
			requestVariables += userDetails
		}
		for (s : r.url.pathVariables)
		{
			var pathVariable = s.toParameter(s.name, s.pathType)
			pathVariable.annotations += annotationRef(PathVariable, s.name)
//			pathVariable.annotations += s.typeAnnotation
			requestVariables += pathVariable
		}
		for (p : r.url.parameters)
		{
			var requestParam = p.toParameter(p.name, p.paramType)
			requestParam.annotations +=
				annotationRef(RequestParam, p.name).booleanValues(
					new Pair<String, Boolean>("required", p.required))
			requestVariables += requestParam
		}
		return requestVariables
	}

	def postParameters(Request r)
	{
		val parameters = new ArrayList<JvmFormalParameter>
		var param = r.toParameter(r.entity.name.toFirstLower, typeRef(r.entity.className))
		param.annotations += annotationRef(Valid)
		param.annotations += annotationRef(RequestBody)
		parameters += param
		parameters += r.toParameter("bindingResult", typeRef(BindingResult))
		return parameters
	}

	def pagingParameters(Request r)
	{
		val parameters = new ArrayList<JvmFormalParameter>
		val required = new Pair<String, Boolean>("required", false)

		val pageDefault = new Pair<String, String>("defaultValue", "0")
		var Pair<String, String> pageValue
		var Pair<String, String> sizeValue
		if (r.paging !== null)
		{
			pageValue = new Pair<String, String>("value", r.paging.page ?: "page")
			sizeValue = new Pair<String, String>("value", r.paging.size ?: "size")
		}
		else
		{
			pageValue = new Pair<String, String>("value", "page")
			sizeValue = new Pair<String, String>("value", "size")
		}
		val sizeDefault = new Pair<String, String>("defaultValue", "10")

		val page = r.toParameter("page", typeRef(int))
		page.annotations +=
			annotationRef(RequestParam).stringValues(pageValue, pageDefault).booleanValues(required)
		parameters += page

		val size = r.toParameter("size", typeRef(int))
		size.annotations +=
			annotationRef(RequestParam).stringValues(sizeValue, sizeDefault).booleanValues(required)
		parameters += size

		return parameters
	}

	def toController(RequestGroup rg)
	{
		return rg.toClass(rg.controllerName, [
			annotations += annotationRef(RestController)

			members += rg.toField(rg.name.toFirstLower + "Service", typeRef(rg.serviceName), [
				annotations += annotationRef(Autowired)
			])

			for (r : rg.requests)
			{
				val isGet = r.method == Method.GET
				val isPost = r.method == Method.POST
				val responseEntity = typeRef(ResponseEntity, r.responseEntityType ?: inferredType)
				members += r.toMethod(r.methodName, responseEntity) [
					annotations += annotationRef(r.method.toMapping, r.url.urlName)

					val requestVariables = r.toRequestVariables
					parameters += requestVariables

					if (isPost)
					{
						parameters += r.postParameters
					}
					else if (isGet && r.pageable)
					{
						parameters += r.pagingParameters
					}

					body = '''
						«IF isPost»
							if (bindingResult.hasErrors())
							{
								return new «responseEntity»(«HttpStatus».BAD_REQUEST);
							}
						«ELSEIF r.pageable»
							«typeRef(Pageable)» pageable = new «typeRef(PageRequest)»(page, size);
						«ENDIF»
						«IF isGet»return new «responseEntity»(«rg.name.toFirstLower»Service.«r.methodName»(«FOR v : requestVariables SEPARATOR ", "»«v.name»«ENDFOR»«IF r.pageable»«IF !requestVariables.empty», «ENDIF»pageable«ENDIF»), «HttpStatus».OK);«ENDIF»
						«IF isPost»«rg.name.toFirstLower»Service.«r.methodName»(«FOR v : requestVariables»«v.name», «ENDFOR»«r.entity.name.toFirstLower»);
						return new «responseEntity»(«HttpStatus».OK);«ENDIF»
					'''
				]
			}
		])
	}

	def infer(RequestGroup rg, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase,
		JvmAnnotationReferenceBuilder annotationTypesBuilder,
		JvmTypeReferenceBuilder typeReferenceBuilder)
		{
			this._annotationTypesBuilder = annotationTypesBuilder;
			this._typeReferenceBuilder = typeReferenceBuilder;
			if (!isPreIndexingPhase)
			{
				val service = rg.toService
				acceptor.accept(service)

				val controller = rg.toController
				acceptor.accept(controller)
			}
		}
	}
	