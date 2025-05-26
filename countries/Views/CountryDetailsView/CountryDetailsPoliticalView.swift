import SwiftUI

struct CountryDetailsPoliticalView: View {
    let country: CountryDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CountryDetailsSectionHeaderView(title: "Political Information")

            CountryDetailsInfoRowView(label: "Independent", value: country.independent ? "Yes" : "No")
            CountryDetailsInfoRowView(label: "UN Member", value: country.unMember ? "Yes" : "No")

            if let currencies = country.currencies, !currencies.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Currencies:")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    ForEach(Array(currencies.keys), id: \.self) { currencyCode in
                        if let currency = currencies[currencyCode] {
                            HStack {
                                Text(currencyCode)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(currency.name) (\(currency.symbol))")
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
