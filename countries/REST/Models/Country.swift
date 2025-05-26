struct Country: Codable, Identifiable, Hashable {
    var id: String { cca2 }

    let name: NativeName
    let cca2: String
    let flag: String
}

extension Country {
    var title: String {
        flag + " " + name.common
    }
}
