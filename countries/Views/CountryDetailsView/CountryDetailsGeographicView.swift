import SwiftUI

struct CountryDetailsGeographicView: View {
    let country: CountryDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CountryDetailsSectionHeaderView(title: "Geographic Information")

            if country.latlng.count == 2 {
                CountryDetailsInfoRowView(label: "Latitude", value: "\(country.latlng[0])°")
                CountryDetailsInfoRowView(label: "Longitude", value: "\(country.latlng[1])°")
            }

            CountryDetailsInfoRowView(label: "Timezones", value: country.timezones.joined(separator: ", "))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
