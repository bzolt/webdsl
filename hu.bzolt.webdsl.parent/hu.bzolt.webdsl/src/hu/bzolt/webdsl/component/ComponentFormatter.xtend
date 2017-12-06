package hu.bzolt.webdsl.component

import com.google.common.base.Strings
import hu.bzolt.webdsl.webDsl.Component
import hu.bzolt.webdsl.webDsl.Excep
import hu.bzolt.webdsl.webDsl.WebDslPackage
import java.util.ArrayList
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
		c.entities.forEach [ e |
			e.prepend[newLine]
			e.format
			e.append[newLines = 2]
		]

		c.formatExceps(document)

		c.requests.forEach [ r | r.format]
		c.requests.reverseView.tail.forEach [ r |
			r.append[setNewLines(1, 1, 2)]
		]
	}

	def formatExceps(Component c, extension IFormattableDocument document)
	{
		c.exceps.reverseView.tail.forEach [ e |
			e.append[setNewLines(1, 1, 2)]
		]
		var exceps = c.exceps.drop(0)
		while (!exceps.empty)
		{
			val group = new ArrayList<Excep>
			group += exceps.head
			var i = 1
			while (i < exceps.size && exceps.get(i).previousHiddenRegion.lineCount <= 2)
			{
				group += exceps.get(i)
				i++
			}

			val width = group.map[regionFor.feature(WebDslPackage.Literals.EXCEP__NAME).length].
				max + 1;
			for (e : group)
			{
				val region = e.regionFor.feature(WebDslPackage.Literals.EXCEP__NAME)
				region.append[space = Strings.repeat(" ", width - region.length)]
				e.regionFor.keyword("->").append[oneSpace]
			}

			exceps = exceps.drop(i)
		}
		c.exceps.last.append[newLines = 2]
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
