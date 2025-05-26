import SwiftUI

struct CountryDetailsView: View {
    let country: Country
    let countriesController: CountriesController

    @State private var viewState: ViewState<CountryDetails> = .loading
    
    var body: some View {
        VStack {
            switch viewState {
            case .loading:
                ProgressView()
            case .error:
                Text("Error while loading country details")
            case .loaded(let countryDetails):
                CountryDetailsSectionsView(country: country, countryDetails: countryDetails)
            }
        }
        .onAppear() {
            countriesController.loadCountryDetails(country: country) { countryDetails in
                viewState = countryDetails.map(ViewState.loaded) ?? .error
            }
        }
    }
}
