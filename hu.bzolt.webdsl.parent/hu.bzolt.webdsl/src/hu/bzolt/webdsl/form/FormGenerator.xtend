package hu.bzolt.webdsl.form

import com.google.inject.Inject
import hu.bzolt.webdsl.field.FieldGenerator
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Field
import hu.bzolt.webdsl.webDsl.Form
import hu.bzolt.webdsl.webDsl.HtmlBody
import org.eclipse.xtext.generator.IFileSystemAccess

class FormGenerator
{
	@Inject
	extension InferrerHelper

	@Inject
	extension FieldGenerator

	def generate(Form f, IFileSystemAccess fsa)
	{
		fsa.generateFile(f.htmlFile, f.compile);
	}

	def compile(Form f)
	'''
		«FOR s : f.segments»«s.compileSegment»«ENDFOR»
	'''
	
	def dispatch compileSegment(HtmlBody h) {
		return h.text.replaceAll("((?:``)*)~$", "$1").replaceAll("`(.)", "$1").replaceFirst("^~", "")
	}
	
	def dispatch compileSegment(Field f) {
		return f.compile((f.eContainer as Form ).request.entity.name.toFirstLower)
	} 
}
