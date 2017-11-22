package hu.bzolt.webdsl.component

import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.Component
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class ComponentValidator extends AbstractDeclarativeValidator
{
	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkComponentStartsWithCapital(Component c)
	{
		if (!Character.isUpperCase(c.name.charAt(0)))
		{
			warning("The name of a component should start with a capital",
				WebDslPackage.Literals.ABSTRACT_ELEMENT__NAME, WebDslValidator.INVALID_NAME,
				c.name)
		}
	}
}
