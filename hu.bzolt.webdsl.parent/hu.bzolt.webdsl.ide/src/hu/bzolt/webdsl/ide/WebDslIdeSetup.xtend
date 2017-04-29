/*
 * generated by Xtext 2.11.0
 */
package hu.bzolt.webdsl.ide

import com.google.inject.Guice
import hu.bzolt.webdsl.WebDslRuntimeModule
import hu.bzolt.webdsl.WebDslStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class WebDslIdeSetup extends WebDslStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new WebDslRuntimeModule, new WebDslIdeModule))
	}
	
}