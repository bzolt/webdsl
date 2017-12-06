package hu.bzolt.webdsl.component

import com.google.inject.Inject
import hu.bzolt.webdsl.entity.EntityFormatter
import hu.bzolt.webdsl.webDsl.Component
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.formatting2.FormatterRequest
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.formatting2.XbaseFormatter

class ComponentFormatter extends XbaseFormatter
{
	@Inject
	EntityFormatter entityFormatter
	
	def dispatch void format(Component c, extension IFormattableDocument document)
	{
		c.regionFor.keyword("Component").prepend[noSpace]
		c.regionFor.feature(WebDslPackage.Literals.ABSTRACT_ELEMENT__NAME).prepend[oneSpace]
		interior(
			c.regionFor.keyword("{").surround[newLine],
			c.regionFor.keyword("}").prepend[newLine],
			[indent]
		)
		c.entities.forEach[e |
			e.prepend[newLine]
			entityFormatter.format(e, document)
		]
		c.exceps.forEach[e |
			e.prepend[newLine]
		]
		c.requests.forEach[r |
			r.prepend[newLine]
		]
	}
	
	def init(FormatterRequest request)
	{
		initialize(request)
		entityFormatter.init(request)
	}

	def res()
	{
		reset
		entityFormatter.res
	}
}
