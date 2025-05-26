import SwiftUI

struct CountryDetailsSectionsView: View {
    let country: Country
    let countryDetails: CountryDetails

    private var showCulturalDetails: Bool {
        !(countryDetails.languages ?? [:]).isEmpty || !(countryDetails.name.nativeName ?? [:]).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CountryDetailsHeaderView(country: country)
                CountryDetailsBasicInfoView(country: countryDetails)
                CountryDetailsGeographicView(country: countryDetails)
                CountryDetailsPoliticalView(country: countryDetails)
                if showCulturalDetails {
                    CountryDetailsCulturalView(country: countryDetails)
                }
            }
            .padding()
        }
    }
}
