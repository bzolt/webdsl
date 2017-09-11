package hu.bzolt.webdsl.requestgroup

import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.RequestGroup
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class RequestGroupValidator extends AbstractDeclarativeValidator
{
	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkRequestGroupStartsWithCapital(RequestGroup rg)
	{
		if (!Character.isUpperCase(rg.name.charAt(0)))
		{
			warning("The name of a request group should start with a capital",
				WebDslPackage.Literals.ABSTRACT_ELEMENT__NAME, WebDslValidator.INVALID_NAME,
				rg.name)
		}
	}
}
	