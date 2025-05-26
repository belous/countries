import SwiftUI

struct CountryDetailsHeaderView: View {
    let country: Country

    var body: some View {
        VStack(spacing: 16) {
            Text(country.flag)
                .font(.system(size: 100))

            VStack(spacing: 8) {
                Text(country.name.official)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(country.name.common)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
