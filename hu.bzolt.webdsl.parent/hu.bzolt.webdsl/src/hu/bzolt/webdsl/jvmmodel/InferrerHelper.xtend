package hu.bzolt.webdsl.jvmmodel

import hu.bzolt.webdsl.webDsl.Attribute
import hu.bzolt.webdsl.webDsl.Component
import hu.bzolt.webdsl.webDsl.Entity
import hu.bzolt.webdsl.webDsl.EntityRef
import hu.bzolt.webdsl.webDsl.Excep
import hu.bzolt.webdsl.webDsl.FieldRef
import hu.bzolt.webdsl.webDsl.Form
import hu.bzolt.webdsl.webDsl.PathConstraint
import hu.bzolt.webdsl.webDsl.Request
import hu.bzolt.webdsl.webDsl.Url
import hu.bzolt.webdsl.webDsl.UrlSegment
import java.util.List
import org.eclipse.emf.common.util.URI

class InferrerHelper
{
	val webResourcesPath = "main/webapp/resources"

	public val Autowired = "org.springframework.beans.factory.annotation.Autowired";
	public val Pageable = "org.springframework.data.domain.Pageable";
	public val PageRequest = "org.springframework.data.domain.PageRequest";
	public val DateTimeFormat = "org.springframework.format.annotation.DateTimeFormat";
	public val ISO = "org.springframework.format.annotation.DateTimeFormat.ISO";
	public val HttpStatus = "org.springframework.http.HttpStatus";
	public val ResponseEntity = "org.springframework.http.ResponseEntity";
	public val AuthenticationPrincipal = "org.springframework.security.core.annotation.AuthenticationPrincipal";
	public val UserDetails = "org.springframework.security.core.userdetails.UserDetails";
	public val BindingResult = "org.springframework.validation.BindingResult";
	public val ControllerAdvice = "org.springframework.web.bind.annotation.ControllerAdvice";
	public val ExceptionHandler = "org.springframework.web.bind.annotation.ExceptionHandler";
	public val GetMapping = "org.springframework.web.bind.annotation.GetMapping";
	public val PathVariable = "org.springframework.web.bind.annotation.PathVariable";
	public val PostMapping = "org.springframework.web.bind.annotation.PostMapping";
	public val RequestBody = "org.springframework.web.bind.annotation.RequestBody";
	public val RequestParam = "org.springframework.web.bind.annotation.RequestParam";
	public val ResponseBody = "org.springframework.web.bind.annotation.ResponseBody";
	public val RestController = "org.springframework.web.bind.annotation.RestController";

	public val Valid = "javax.validation.Valid";
	public val Future = "javax.validation.constraints.Future";
	public val Max = "javax.validation.constraints.Max";
	public val Min = "javax.validation.constraints.Min";
	public val NotNull = "javax.validation.constraints.NotNull";
	public val Past = "javax.validation.constraints.Past";
	public val Size = "javax.validation.constraints.Size";

	def methodName(Request r)
	{
		return r.method.toString.toLowerCase + r.url.toCamelCase
	}

	def methodName(Excep e)
	{
		return e.name.toFirstLower
	}

	def className(Entity e)
	{
		return e.eResource.URI.basePackage + "." + (e.eContainer as Component).name.toLowerCase + "." + e.name
	}

	def className(Excep e)
	{
		return e.eResource.URI.basePackage + "." + (e.eContainer as Component).name.toLowerCase + "." + e.name + "Exception"
	}

	def serviceName(Component c)
	{
		return c.eResource.URI.basePackage + "." + c.name.toLowerCase + "." + c.name + "Service"
	}

	def controllerName(Component c)
	{
		return c.eResource.URI.basePackage + "." + c.name.toLowerCase + "." + c.name + "Controller"
	}

	def handlerName(Component c)
	{
		return c.eResource.URI.basePackage + "." + c.name.toLowerCase + "." + c.name +
			"ExceptionHandlingController"
	}

	def htmlFile(Form f)
	{
		return webResourcesPath + "/views/" + f.name.toLowerCase + "form.html"
	}

	def serviceFile(Component c)
	{
		return webResourcesPath + "/js/services/" + c.name.toLowerCase + "service.js"
	}

	def toCamelCase(Url u)
	'''«FOR s : u.segments»«s.name.toFirstUpper»«ENDFOR»'''

	def basePackage(URI uri)
	{
		return uri.segmentsList.reverseView.takeWhile[String s|!s.equals("java")].tail.toList.
			reverseView.join(".");
	}

	def toFileName(String baseName)
	{
		return "main.java" + baseName
	}

	def boolean infiniteFlatLoop(Entity e, List<String> entities)
	{
		for (er : e.attributes.filter[a|a.type instanceof EntityRef].map[a|a.type as EntityRef])
		{
			if (er.flat)
			{
				val erEntity = er.entity
				if (entities.contains(erEntity.name))
				{
					return true
				}
				entities.add(erEntity.name)
				if (infiniteFlatLoop(erEntity, entities))
				{
					return true
				}
			}
		}
		return false
	}

	def urlName(Url u)
	{
		if (u.segments.empty)
		{
			return "/"
		}
		return '''«FOR s : u.segments»/«s.print»«ENDFOR»'''
	}

	def pathVariables(Url u)
	{
		return u.segments.filter[s|s.variable]
	}

	def private print(UrlSegment s)
	'''«IF s.variable»«s.printVariable»«ELSE»«s.printNonVariable»«ENDIF»'''

	def private printNonVariable(UrlSegment s)
	'''«s.name»'''

	def private printVariable(UrlSegment s)
	'''{«s.name»«s.constraint.printConstraint»}'''

	def private printConstraint(PathConstraint constraint)
	'''«IF constraint.equals(PathConstraint.NUMBER)»:^\d{1,10}$«ENDIF»'''

	def Attribute finalAttribute(FieldRef fr)
	{
		if (fr.child === null)
		{
			return fr.attribute
		}
		else
		{
			return fr.child.finalAttribute
		}
	}

	def fullName(FieldRef fr)
	{
		var parent = fr.attribute
		var result = parent.name
		var ref = fr
		while (ref.child !== null)
		{
			ref = ref.child
			var a = ref.attribute
			if ((parent.type as EntityRef).flat)
			{
				result += a.name.toFirstUpper
			}
			else
			{
				result += "." + a.name
			}
			parent = a
		}
		return result
	}
}
