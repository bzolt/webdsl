package hu.bzolt.webdsl.request

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.DomainModel
import hu.bzolt.webdsl.webDsl.Method
import hu.bzolt.webdsl.webDsl.Paging
import hu.bzolt.webdsl.webDsl.Request
import hu.bzolt.webdsl.webDsl.Url
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class RequestValidator extends AbstractDeclarativeValidator
{
	@Inject
	extension InferrerHelper

	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkDuplicateUrl(Request r)
	{
		if (r.countUrl > 1)
		{
			error("Duplicate URL for method " + r.method, r, WebDslPackage.Literals.REQUEST__URL,
				WebDslValidator.DUPLICATE_URL)
		}
	}

	def private countUrl(Request r)
	{
		var count = 0
		val method = r.method
		val url = r.url.urlName
		val dModel = r.eContainer.eContainer as DomainModel
		count = dModel.eAllContents.filter(Request).filter [ r2 |
			r2.method == method && r2.url.urlName == url
		].size
		return count;
	}

	@Check
	def checkListOnGetRequest(Request r)
	{
		if (r.list && r.method == Method.POST)
		{
			error("The modifier 'list of' is only supported on GET request", r,
				WebDslPackage.Literals.REQUEST__LIST, WebDslValidator.INVALID_METHOD_WITH_LIST)
		}
	}

	@Check
	def checkNoPageableConflict(Request r)
	{
		if (r.pageable)
		{
			var parameters = r.url.parameters.map[p|p.name]
			if (r.paging !== null)
			{
				if (parameters.contains(r.paging.page ?: "page"))
				{
					error("The name " + (r.paging.page ?: "page") + " is already taken", r.paging,
						WebDslPackage.Literals.PAGING__PAGE, WebDslValidator.PAGE_OR_SIZE_TAKEN,
						r.paging.page ?: "page")
				}
				if (parameters.contains(r.paging.size ?: "size"))
				{
					error("The name " + (r.paging.size ?: "size") + " is already taken", r.paging,
						WebDslPackage.Literals.PAGING__SIZE, WebDslValidator.PAGE_OR_SIZE_TAKEN,
						r.paging.page ?: "page")
				}
			}
		}
	}

	@Check
	def checkPageableOnlyOnList(Request r)
	{
		if (r.pageable && !r.list)
		{
			error("Pageable request must return list", r, WebDslPackage.Literals.REQUEST__PAGEABLE,
				WebDslValidator.PAGEABLE_NOT_LIST)
		}
	}

	@Check
	def checkRequestParamOnGetRequest(Request r)
	{
		if (r.method == Method.POST && !r.url.parameters.empty)
		{
			error("Request parameters only supported on GET request", r,
				WebDslPackage.Literals.REQUEST__METHOD,
				WebDslValidator.INVALID_METHOD_WITH_REQUEST_PARAMETER)
		}
	}
	
	@Check
	def checkPageAndSizeUnique(Paging p)
	{
		if ((p.page ?: "page").equals(p.size ?: "size"))
		{
			error("Page and size variable can not be the same", p,
				WebDslPackage.Literals.PAGING__PAGE, WebDslValidator.PAGE_AND_SIZE_SAME, p.page)
		}
	}
	
	@Check
	def checkDuplicatePathVariable(Url u)
	{
		var pathVariables = u.pathVariables
		for (var i = 0; i < pathVariables.size - 1; i++)
		{
			for (var j = i + 1; j < pathVariables.size; j++)
			{
				val segment = pathVariables.get(i)
				if (segment.name.equals(pathVariables.get(j).name))
				{
					error("Duplicate path variable name " + segment.name, segment,
						WebDslPackage.Literals.URL_SEGMENT__NAME, WebDslValidator.DUPLICATE_PATH_VARIABLE,
						segment.name)
				}
			}
		}
	}

	@Check
	def checkDuplicateRequestParameter(Url u)
	{
		var requestparameters = u.parameters
		for (var i = 0; i < requestparameters.size - 1; i++)
		{
			for (var j = i + 1; j < requestparameters.size; j++)
			{
				val parameter = requestparameters.get(i)
				if (parameter.name.equals(requestparameters.get(j).name))
				{
					error("Duplicate request parameter name " + parameter.name, parameter,
						WebDslPackage.Literals.REQUEST_PARAMETER__NAME,
						WebDslValidator.DUPLICATE_REQUEST_PARAMETER, parameter.name)
				}
			}
		}
	}
}
	