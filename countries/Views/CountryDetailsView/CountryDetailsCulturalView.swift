import SwiftUI

struct CountryDetailsCulturalView: View {
    let country: CountryDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CountryDetailsSectionHeaderView(title: "Languages & Culture")

            if let languages = country.languages, !languages.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Official Languages:")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    ForEach(Array(languages.keys), id: \.self) { languageCode in
                        if let languageName = languages[languageCode] {
                            HStack {
                                Text(languageCode.uppercased())
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(6)
                                Text(languageName)
                                Spacer()
                            }
                        }
                    }
                }
            }

            if let nativeName = country.name.nativeName, !nativeName.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Native Names:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.top)

                    ForEach(Array(nativeName.keys), id: \.self) { langCode in
                        if let nativeName = nativeName[langCode] {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(langCode.uppercased())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(nativeName.official)
                                    .fontWeight(.medium)
                                if nativeName.common != nativeName.official {
                                    Text(nativeName.common)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.bottom, 4)
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
