/*
 * generated by Xtext 2.11.0
 */
package hu.bzolt.webdsl.validation

import com.google.inject.Inject
import hu.bzolt.webdsl.component.ComponentValidator
import hu.bzolt.webdsl.entity.EntityValidator
import hu.bzolt.webdsl.excep.ExcepValidator
import hu.bzolt.webdsl.field.FieldValidator
import hu.bzolt.webdsl.form.FormValidator
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.request.RequestValidator
import org.eclipse.xtext.validation.ComposedChecks

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
@ComposedChecks(validators=#[EntityValidator, ComponentValidator, ExcepValidator, FieldValidator,
	FormValidator, RequestValidator])
class WebDslValidator extends AbstractWebDslValidator
{
	@Inject
	extension InferrerHelper

	public static val INVALID_NAME = "invalidName"
	public static val INVALID_METHOD_WITH_LIST = "invalidMethodWithList"
	public static val INVALID_METHOD_WITH_REQUEST_PARAMETER = "invalidMethodWithRequestParameter"
	public static val INVALID_STATUS_CODE = "invalidStatusCode"
	public static val DUPLICATE_URL = "duplicateUrl"
	public static val DUPLICATE_PATH_VARIABLE = "duplicatePathVariable"
	public static val DUPLICATE_REQUEST_PARAMETER = "duplicateRequestParameter"
	public static val FORM_FOR_GET_REQUEST = "formForGetRequest"
	public static val WRONG_FORM_ATTRIBUTE = "wrongFormAttribute"
	public static val INVALID_FIELD_TYPE = "invalidFieldType"
	public static val INVALID_FIELD_REFERENCE = "invalidFieldReference"
	public static val INVALID_FALSE_LABEL = "invalidFalseLabel"
	public static val REFERENCE_ON_SIMPLE_ATTRIBUTE = "referenceOnSimpleAttribute"
	public static val FLATTENED_LIST = "flattenedList"
	public static val INFINITE_FLAT_LOOP = "infiniteFlatLoop"
	public static val PAGEABLE_NOT_LIST = "pageableNotList"
	public static val PAGE_AND_SIZE_SAME = "pageAndSizeSame"
	public static val PAGE_OR_SIZE_TAKEN = "pageOrSizeTaken"

}
