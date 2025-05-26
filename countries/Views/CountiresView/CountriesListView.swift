import SwiftUI

struct CountriesListView: View {
    let countries: [Country]
    let countriesController: CountriesController

    @State private var searchText: String = ""

    var body: some View {
        List {
            ForEach(countries.filter { searchText.isEmpty || $0.name.common.lowercased().hasPrefix(searchText.lowercased())}) { country in
                NavigationLink {
                    CountryDetailsView(country: country, countriesController: countriesController)
                } label: {
                    Text(country.title)
                }
            }
        }
        .searchable(text: $searchText)
    }
}
