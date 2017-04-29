package hu.bzolt.webdsl.jvmmodel

import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.xtext.common.types.JvmEnumerationLiteral
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.TypesFactory

class AnnotationRefHelper
{
	def stringValues(JvmAnnotationReference annotation, Pair<String, String>... params)
	{
		val anno = annotation.annotation
		for (param : params)
		{
			annotation.explicitValues += TypesFactory.eINSTANCE.createJvmStringAnnotationValue => [
				operation = anno.members.filter(JvmOperation).findFirst [
					simpleName == param.key
				]

				values += param.value
			]
		}
		return annotation
	}

	def intValues(JvmAnnotationReference annotation, Pair<String, Integer>... params)
	{
		val anno = annotation.annotation
		for (param : params)
		{
			annotation.explicitValues += TypesFactory.eINSTANCE.createJvmIntAnnotationValue => [
				operation = anno.members.filter(JvmOperation).findFirst [
					simpleName == param.key
				]

				values += param.value
			]
		}
		return annotation
	}

	def booleanValues(JvmAnnotationReference annotation, Pair<String, Boolean>... params)
	{
		val anno = annotation.annotation
		for (param : params)
		{
			annotation.explicitValues += TypesFactory.eINSTANCE.createJvmBooleanAnnotationValue => [
				operation = anno.members.filter(JvmOperation).findFirst [
					simpleName == param.key
				]

				values += param.value
			]
		}
		return annotation
	}

	def classValue(JvmAnnotationReference annotation, JvmTypeReference excepClass)
	{
		annotation.explicitValues += TypesFactory.eINSTANCE.createJvmTypeAnnotationValue => [
			values += excepClass
		]

		return annotation
	}

	def isoValue(JvmAnnotationReference annotation, JvmEnumerationLiteral iso)
	{
		val anno = annotation.annotation
		annotation.explicitValues += TypesFactory.eINSTANCE.createJvmEnumAnnotationValue => [
			operation = anno.members.filter(JvmOperation).findFirst[simpleName == "iso"]
			values += iso
		]

		return annotation
	}
}
