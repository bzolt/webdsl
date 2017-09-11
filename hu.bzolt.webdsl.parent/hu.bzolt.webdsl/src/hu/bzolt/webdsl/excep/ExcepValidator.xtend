package hu.bzolt.webdsl.excep

import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.Excep
import hu.bzolt.webdsl.webDsl.WebDslPackage
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class ExcepValidator extends AbstractDeclarativeValidator
{
	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkExcepStartsWithCapital(Excep e)
	{
		if (!Character.isUpperCase(e.name.charAt(0)))
		{
			warning("The name of an exception should start with a capital",
				WebDslPackage.Literals.EXCEP__NAME, WebDslValidator.INVALID_NAME, e.name)
		}
	}

//		@Check
//		def checkValidStatusCode(Excep e)
//		{
//			try
//			{
//				HttpStatus.valueOf(e.code)
//			}
//			catch (IllegalArgumentException exception)
//			{
//				error("Invalid HTTP status code " + e.code, e, WebDslPackage.Literals.EXCEP__CODE,
//					WebDslValidator.INVALID_STATUS_CODE, e.code.toString)
//			}
//		}
}
