struct CountryDetails: Codable, Equatable {
    static func == (lhs: CountryDetails, rhs: CountryDetails) -> Bool {
        lhs.cca2 == rhs.cca2
    }

    let name: CountryName
    let tld: [String]
    let cca2: String
    let independent: Bool
    let unMember: Bool
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: String
    let subregion: String?
    let languages: [String: String]?
    let latlng: [Double]
    let area: Double
    let population: Int
    let timezones: [String]
}
