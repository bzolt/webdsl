package hu.bzolt.webdsl.jvmmodel;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.common.types.JvmAnnotationReference;
import org.eclipse.xtext.common.types.JvmAnnotationType;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmStringAnnotationValue;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.common.types.TypesFactory;
import org.eclipse.xtext.common.types.util.TypeReferences;
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder;
import org.eclipse.xtext.xbase.lib.Pair;

import com.google.inject.Inject;

/*
 * Source:
 * https://www.eclipse.org/forums/index.php?t=msg&th=489204&goto=1081053&#msg_1081053
 */
public class ExtendedJvmTypesBuilder extends JvmTypesBuilder
{
	@Inject
	private TypeReferences references;

	@Inject
	private TypesFactory typesFactory;

	public JvmAnnotationReference toAnnotationExtended(EObject sourceElement,
			String annotationTypeName, Pair<String, String>... values)
	{
		JvmAnnotationReference result = typesFactory.createJvmAnnotationReference();
		JvmType jvmType = references.findDeclaredType(annotationTypeName, sourceElement);
		if (jvmType == null)
		{
			throw new IllegalArgumentException(
					"The type " + annotationTypeName + " is not on the classpath.");
		}
		if (!(jvmType instanceof JvmAnnotationType))
		{
			throw new IllegalArgumentException(
					"The given class " + annotationTypeName + " is not an annotation type.");
		}
		JvmAnnotationType annotationType = (JvmAnnotationType) jvmType;
		result.setAnnotation(annotationType);

		for (Pair<String, String> value : values)
		{
			JvmStringAnnotationValue annotationValue = typesFactory
					.createJvmStringAnnotationValue();
			annotationValue.getValues().add(value.getValue());
			JvmOperation operation = getJvmOperation(annotationType, value.getKey());
			if (operation != null)
			{
				annotationValue.setOperation(operation);
			}
			result.getExplicitValues().add(annotationValue);
		}

		return result;
	}

	private JvmOperation getJvmOperation(JvmAnnotationType type, String name)
	{
		for (JvmOperation op : type.getDeclaredOperations())
		{
			if (op.getSimpleName().equals(name))
			{
				return op;
			}
		}
		return null;
	}
}
