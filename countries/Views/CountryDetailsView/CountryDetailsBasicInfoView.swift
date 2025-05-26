import SwiftUI

struct CountryDetailsBasicInfoView: View {
    let country: CountryDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CountryDetailsSectionHeaderView(title: "Basic Information")

            CountryDetailsInfoRowView(label: "Capital", value: country.capital?.joined(separator: ", ") ?? "N/A")
            CountryDetailsInfoRowView(label: "Population", value: "\(country.population)")
            CountryDetailsInfoRowView(label: "Area", value: "\(country.area.formatted()) km²")
            CountryDetailsInfoRowView(label: "Region", value: country.region)
            CountryDetailsInfoRowView(label: "Subregion", value: country.subregion ?? "N/A")
            CountryDetailsInfoRowView(label: "Country Code", value: country.cca2)
            CountryDetailsInfoRowView(label: "Top Level Domain", value: country.tld.joined(separator: ", "))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
