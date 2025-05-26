struct CountryName: Codable {
    let common: String
    let official: String
    let nativeName: [String: NativeName]?
}
