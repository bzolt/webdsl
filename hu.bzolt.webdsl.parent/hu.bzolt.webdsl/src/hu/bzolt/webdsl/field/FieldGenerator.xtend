package hu.bzolt.webdsl.field

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Field
import hu.bzolt.webdsl.webDsl.Num
import hu.bzolt.webdsl.webDsl.Text
import hu.bzolt.webdsl.webDsl.Type

class FieldGenerator
{
	@Inject
	extension InferrerHelper

	def compile(Field f, String entityName)
	{
		val fullName = f.ref.fullName
		val finalAttribute = f.ref.finalAttribute
		return
		''' data-ng-model="«entityName».«fullName»"«IF finalAttribute.required» required=""«ENDIF» «finalAttribute.type.compileValidation» '''
	}

	def dispatch compileValidation(Text t)
	{
		var result = ""
		result += if (t.minLength > 0) 'pattern=".{' + t.minLength + ',}" '
		result += if (t.maxLength > 0) 'maxlength="' + t.maxLength + '" '
		return result
	}

	def dispatch compileValidation(Num n)
	{
		var result = ""
		result += if (n.min > 0) 'min="' + n.min + '" '
		result += if (n.max > 0) 'max="' + n.max + '" '
		return result
	}

	def dispatch compileValidation(Type t)
	{
	}
}
