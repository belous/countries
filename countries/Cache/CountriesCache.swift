import Foundation

final class CountriesCache: @unchecked Sendable {

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let fileManager = FileManager.default
    private let cacheQueue = DispatchQueue(label: "se.belous.dev.countries.cache.queue", attributes: .concurrent)
    private let cacheDirectory: URL
    private let countriesURL: URL

    init() throws {
        let cachesDirectory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        self.cacheDirectory = cachesDirectory.appendingPathComponent("CountriesCache")
        try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        self.countriesURL = cacheDirectory.appendingPathComponent("countries.json")
    }

    private func loadFromCache<T: Codable>(_ type: T.Type, from url: URL, description: String) -> T? {
        cacheQueue.sync { [weak self] in
            guard let self = self else { return nil }

            guard fileManager.fileExists(atPath: url.path) else { return nil }

            do {
                let data = try Data(contentsOf: url)
                let decodedData = try decoder.decode(type, from: data)
                print("Successfully loaded cached \(description)")
                return decodedData
            } catch {
                print("Error while loading cached \(description): \(error)")
                return nil
            }
        }
    }

    private func saveToCache<T: Codable>(_ data: T, to url: URL, description: String) where T: Sendable {
        cacheQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }

            do {
                let encodedData = try encoder.encode(data)
                try encodedData.write(to: url, options: .atomic)
                print("Successfully cached \(description)")
            } catch {
                print("Error while caching \(description): \(error)")
            }
        }
    }
}

extension CountriesCache {
    func getCountries() -> [Country]? {
        loadFromCache([Country].self, from: countriesURL, description: "countries")
    }

    func saveCountries(_ countries: [Country]) {
        saveToCache(countries, to: countriesURL, description: "\(countries.count) countries")
    }
}

extension CountriesCache {
    func getCountryDetails(for countryCode: String) -> CountryDetails? {
        let fileName = sanitizeFileName(countryCode) + ".json"
        let countryURL = cacheDirectory.appendingPathComponent(fileName)
        return loadFromCache(CountryDetails.self, from: countryURL, description: "country details for \(countryCode)")
    }

    func saveCountryDetails(_ details: CountryDetails, for countryCode: String) {
        let fileName = sanitizeFileName(countryCode) + ".json"
        let countryURL = cacheDirectory.appendingPathComponent(fileName)
        saveToCache(details, to: countryURL, description: "details for country: \(countryCode)")
    }
}

extension CountriesCache {
    private func sanitizeFileName(_ fileName: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: "/<>:\"|?*")
        return fileName.components(separatedBy: invalidCharacters).joined(separator: "_")
    }
}
