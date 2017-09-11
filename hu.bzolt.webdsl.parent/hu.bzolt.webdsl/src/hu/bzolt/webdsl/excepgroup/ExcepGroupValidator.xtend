package hu.bzolt.webdsl.excepgroup

import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.ExcepGroup
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class ExcepGroupValidator extends AbstractDeclarativeValidator
{
	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkExcepGroupStartsWithCapital(ExcepGroup eg)
	{
		if (!Character.isUpperCase(eg.name.charAt(0)))
		{
			warning("The name of a request group should start with a capital",
				WebDslPackage.Literals.ABSTRACT_ELEMENT__NAME, WebDslValidator.INVALID_NAME,
				eg.name)
			}
		}
	}
	