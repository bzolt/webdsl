package hu.bzolt.webdsl.form

import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.Entity
import hu.bzolt.webdsl.webDsl.EntityRef
import hu.bzolt.webdsl.webDsl.Field
import hu.bzolt.webdsl.webDsl.Form
import hu.bzolt.webdsl.webDsl.Method
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class FormValidator extends AbstractDeclarativeValidator
{
	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkFormAttribute(Form f)
	{
		for (field : f.segments.filter(Field))
		{
			var entity = f.request.entity
			var ref = field.ref
			if ((ref.attribute.eContainer as Entity) != entity)
			{
				error("The attribute is not part of the entity associated with the request", ref,
					WebDslPackage.Literals.FIELD_REF__ATTRIBUTE,
					WebDslValidator.WRONG_FORM_ATTRIBUTE)
			}
			while (ref.child !== null)
			{
				entity = (ref.attribute.type as EntityRef).entity
				ref = ref.child
				if ((ref.attribute.eContainer as Entity) != entity)
				{
					error("The attribute is not part of the entity '" + entity.name + "'", ref,
						WebDslPackage.Literals.FIELD_REF__ATTRIBUTE,
						WebDslValidator.WRONG_FORM_ATTRIBUTE)
				}
			}
		}
	}

	@Check
	def checkFormRequestMethod(Form f)
	{
		if (f.request.method != Method.POST)
		{
			error("Forms can only be declared for POST requests", f,
				WebDslPackage.Literals.FORM__REQUEST, WebDslValidator.FORM_FOR_GET_REQUEST)
		}
	}
}
		