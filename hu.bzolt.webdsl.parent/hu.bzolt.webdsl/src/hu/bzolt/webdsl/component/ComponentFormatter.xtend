package hu.bzolt.webdsl.component

import hu.bzolt.webdsl.webDsl.Component
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.formatting2.FormatterRequest
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.formatting2.XbaseFormatter

class ComponentFormatter extends XbaseFormatter
{
	def dispatch void format(Component c, extension IFormattableDocument document)
	{
		c.regionFor.keyword("Component").prepend[noSpace]
		c.regionFor.feature(WebDslPackage.Literals.ABSTRACT_ELEMENT__NAME).prepend[oneSpace]
		interior(
			c.regionFor.keyword("{").surround[newLine],
			c.regionFor.keyword("}").prepend[newLine],
			[indent]
		)
	}
	
	def init(FormatterRequest request)
	{
		initialize(request)
	}

	def res()
	{
		reset
	}
}
