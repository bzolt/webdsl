package hu.bzolt.webdsl.form

import com.google.inject.Inject
import hu.bzolt.webdsl.field.FieldGenerator
import hu.bzolt.webdsl.jvmmodel.InferrerHelper
import hu.bzolt.webdsl.webDsl.Component
import hu.bzolt.webdsl.webDsl.Form
import hu.bzolt.webdsl.webDsl.Num
import org.eclipse.xtext.generator.IFileSystemAccess

class FormGenerator
{
	@Inject
	extension InferrerHelper

	@Inject
	extension FieldGenerator

	def generate(Form f, IFileSystemAccess fsa)
	{
		fsa.generateFile(f.controllerFile, f.compileController);
		fsa.generateFile(f.htmlFile, f.compileHtml);
	}

	def compileController(Form f)
	{
		val componentName = (f.request.eContainer as Component).name
		return '''
			app.controller("«f.name»Controller", [ "$scope", "«componentName»Service", 
				function($scope, «componentName»Service) {
					$scope.«f.request.entity.name.toFirstLower» = {};
					«FOR field : f.fields»
						«IF field.^default !== null»
							$scope.«f.request.entity.name.toFirstLower».«field.ref.fullName» = «if (field.ref.finalAttribute.type != Num)  '"'»«field.^default»«if (field.ref.finalAttribute.type != Num)  '"'»;
						«ENDIF»
					«ENDFOR»
					
					$scope.submit = function() {
						«componentName»Service.«f.request.url.toCamelCase»«f.request.method.toString.toLowerCase.toFirstUpper»($scope.«f.request.entity.name.toFirstLower»).then(function(response) {
							«f.name»Service.succes(response);
						}, function(response)
						{
							«f.name»Service.error(response);
						});
					};
				} ]);
		'''
	}

	def compileHtml(Form f)
	'''
		<form name="form" data-ng-submit="submit()" data-ng-controller="«f.name»Controller" novalidate="">
			«FOR field : f.fields»
				«field.compile(f.request.entity.name.toFirstLower)»
			«ENDFOR»
			<button type="submit" value="«f.submit?:"Submit"»"/>
		</form>
	'''
}
