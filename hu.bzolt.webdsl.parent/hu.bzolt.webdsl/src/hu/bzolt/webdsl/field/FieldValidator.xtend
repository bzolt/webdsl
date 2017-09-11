package hu.bzolt.webdsl.field

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.Bool
import hu.bzolt.webdsl.webDsl.Date
import hu.bzolt.webdsl.webDsl.EntityRef
import hu.bzolt.webdsl.webDsl.Field
import hu.bzolt.webdsl.webDsl.FieldRef
import hu.bzolt.webdsl.webDsl.FieldType
import hu.bzolt.webdsl.webDsl.Num
import hu.bzolt.webdsl.webDsl.Text
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class FieldValidator extends AbstractDeclarativeValidator
{
	@Inject
	extension InferrerHelper

	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkInvalidFalseLabel(Field f)
	{
		if (f.falseLabel !== null && f.type != FieldType.RADIO)
		{
			error("The false label can be declared only on radio type field", f,
				WebDslPackage.Literals.FIELD__FALSE_LABEL, WebDslValidator.INVALID_FALSE_LABEL)
		}
	}

	@Check
	def checkInvalidFieldType(Field f)
	{
		var type = f.ref.finalAttribute.type
		switch (type)
		{
			Text:
			{
				if (!(f.type == FieldType.TEXT || f.type == FieldType.AREA))
				{
					error("The type is invalid for text attribute", f,
						WebDslPackage.Literals.FIELD__TYPE, WebDslValidator.INVALID_FIELD_TYPE)
				}
			}
			Num:
			{
				if (!(f.type == FieldType.NUMBER || f.type == FieldType.RANGE))
				{
					error("The type is invalid for number attribute", f,
						WebDslPackage.Literals.FIELD__TYPE, WebDslValidator.INVALID_FIELD_TYPE)
				}
			}
			Bool:
			{
				if (!(f.type == FieldType.CHECKBOX || f.type == FieldType.RADIO))
				{
					error("The type is invalid for bool attribute", f,
						WebDslPackage.Literals.FIELD__TYPE, WebDslValidator.INVALID_FIELD_TYPE)
				}
			}
			Date:
			{
				if (f.type != FieldType.DATE)
				{
					error("The type is invalid for date attribute", f,
						WebDslPackage.Literals.FIELD__TYPE, WebDslValidator.INVALID_FIELD_TYPE)
				}
			}
			EntityRef:
			{
				error("Only simple attribute can be declared as form field", f,
					WebDslPackage.Literals.FIELD__REF, WebDslValidator.INVALID_FIELD_REFERENCE)
			}
		}
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
	