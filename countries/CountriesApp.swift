import SwiftUI

@main
struct CountriesApp: App {
    let countriesController = CountriesController()

    var body: some Scene {
        WindowGroup {
            CountiresView(countriesController: countriesController)
        }
    }
}
