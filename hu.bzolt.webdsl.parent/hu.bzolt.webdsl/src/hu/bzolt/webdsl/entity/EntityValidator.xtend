package hu.bzolt.webdsl.entity

import com.google.inject.Inject
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.validation.WebDslValidator
import hu.bzolt.webdsl.webDsl.Attribute
import hu.bzolt.webdsl.webDsl.Entity
import hu.bzolt.webdsl.webDsl.EntityRef
import hu.bzolt.webdsl.webDsl.WebDslPackage
import java.util.ArrayList
import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.EValidatorRegistrar

class EntityValidator extends AbstractDeclarativeValidator
{
	@Inject
	extension InferrerHelper

	override register(EValidatorRegistrar registrar)
	{
	}

	@Check
	def checkEntityStartsWithCapital(Entity e)
	{
		if (!Character.isUpperCase(e.name.charAt(0)))
		{

			warning("The name of an entity should start with a capital",
				WebDslPackage.Literals.ABSTRACT_ELEMENT__NAME, WebDslValidator.INVALID_NAME, e.name)
		}
	}

	@Check
	def checkInfiniteFlatLoop(EntityRef er)
	{
		if (er.flat)
		{
			var entities = new ArrayList<String>
			entities.add((er.eContainer.eContainer as Entity).name)
			entities.add(er.entity.name)
			if (infiniteFlatLoop(er.entity, entities))
			{
				error("Infinite flattening loop", WebDslPackage.Literals.ENTITY_REF__FLAT,
					WebDslValidator.INFINITE_FLAT_LOOP)
			}
		}
	}

	@Check
	def checkListNotFlattened(EntityRef er)
	{
		if (er.flat && (er.eContainer as Attribute).list)
		{
			error("List cannot be flattened", WebDslPackage.Literals.ENTITY_REF__FLAT,
				WebDslValidator.FLATTENED_LIST)
		}
	}
}
