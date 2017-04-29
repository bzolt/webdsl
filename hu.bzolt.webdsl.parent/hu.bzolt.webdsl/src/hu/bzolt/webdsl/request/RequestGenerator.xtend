package hu.bzolt.webdsl.request

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Method
import hu.bzolt.webdsl.webDsl.Request
import hu.bzolt.webdsl.webDsl.Url
import java.util.ArrayList

class RequestGenerator
{
	@Inject
	extension InferrerHelper

	def compile(Request r)
	{
		val params = r.functionParameters
		return '''			
			this.«r.url.toCamelCase»«r.method.toString.toLowerCase.toFirstUpper» = function(«params.join(", ")»«IF r.method == Method.POST»«if (!params.empty) ", "»«r.entity.name.toLowerCase»«ENDIF») {
				«IF (!r.url.parameters.empty)»
					config = {};
					config.params = {};
					«FOR p: r.url.parameters»
						config.params.«p.name» = «p.name»;
					«ENDFOR»
					«IF r.pageable»
						config.params.«r.paging.page ?: "page"» = page;
						config.params.«r.paging.size ?: "size"» = size;
					«ENDIF»
				«ENDIF»
				return $http.«r.method.toString.toLowerCase»(«r.url.urlWithVariables», «IF r.method == Method.POST»«r.entity.name.toLowerCase»«ELSE»«if (r.url.parameters.empty) "null" else "config"»«ENDIF»);
			};
		'''
	}

	def private functionParameters(Request r)
	{
		var parameters = new ArrayList<String>
		parameters += r.url.pathVariables.map[p|p.name]
		parameters += r.url.parameters.map[p|p.name]
		if (r.pageable)
		{
			parameters += "page"
			parameters += "size"
		}
		return parameters
	}

	def private urlWithVariables(Url u)
	{
		if (u.segments.empty)
		{
			return '"/"'
		}
		else
		{
			return '''"«FOR s : u.segments»/«IF s.variable»" + «ENDIF»«s.name»«IF s.variable» + "«ENDIF»«ENDFOR»"'''
		}
	}
}
