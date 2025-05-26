import SwiftUI

struct CountiresView: View {
    let countriesController: CountriesController

    @State private var viewState: ViewState<[Country]> = .loading

    var body: some View {
        NavigationStack {
            VStack {
                switch viewState {
                case .loading:
                    ProgressView()
                case .loaded(let countries):
                    CountriesListView(countries: countries, countriesController: countriesController)
                case .error:
                    Text("Error while loading countries")
                }
            }
            .navigationTitle("Countries")
        }
        .onAppear() {
            countriesController.loadCountries { countries in
                viewState = countries.map(ViewState.loaded) ?? .error
            }
        }
    }
}
