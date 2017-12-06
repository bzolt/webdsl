package hu.bzolt.webdsl.field

import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.EntityRef
import hu.bzolt.webdsl.webDsl.FieldRef
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class FieldValidator extends AbstractDeclarativeValidator
{
	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkFieldRef(FieldRef fr)
	{
		if (fr.child !== null && !(fr.attribute.type instanceof EntityRef))
		{
			error("The attribute '" + fr.attribute.name + "' is a simple attribute", fr,
				WebDslPackage.Literals.FIELD_REF__ATTRIBUTE,
				WebDslValidator.REFERENCE_ON_SIMPLE_ATTRIBUTE)
			}
		}
	}
	