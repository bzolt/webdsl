package hu.bzolt.webdsl.field

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Field
import hu.bzolt.webdsl.webDsl.FieldType
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
		return '''
			«IF f.type == FieldType.RADIO»
				<label><input type="radio" data-ng-model="«entityName».«fullName»" data-ng-value="true">«f.label?:"True"»</label>
				<label><input type="radio" data-ng-model="«entityName».«fullName»" data-ng-value="false">«f.falseLabel?:"False"»</label>
			«ELSE»
				<label>
					<input type="«f.type.literal»" name="«fullName»" data-ng-model="«entityName».«fullName»" 
					placeholder="«f.placeholder?:""»" «IF finalAttribute.required»required=""«ENDIF» «finalAttribute.type.compileValidation» />«f.label?:finalAttribute.name»
				</label>
				«IF true»
					<div ng-show="form.$submitted || form.«fullName».$touched">
						<span ng-show="form.«fullName».$error">«f.error?:"Please fill correctly."»</span>
					</div>
				«ENDIF»
			«ENDIF» 
		'''
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
