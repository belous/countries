import Testing
import Foundation

@testable import countries

struct CountriesServiceTests {

    @Test("Fetch countries successfully")
    func fetchCountriesSuccess() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)

        let expectedCountries = [
            Country(name: NativeName(official: "Federal Republic of Germany", common: "Germany"), cca2: "DE", flag: "🇩🇪"),
            Country(name: NativeName(official: "French Republic", common: "France"), cca2: "FR", flag: "🇫🇷"),
        ]

        let jsonData = try JSONEncoder().encode(expectedCountries)
        mockSession.data = jsonData

        let result = await withCheckedContinuation { continuation in
            service.fetchCountries { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success(let countries):
            #expect(countries == expectedCountries)

        case .failure(let error):
            Issue.record("Expected success but got error: \(error)")
        }
    }

    @Test("Fetch countries with network error")
    func fetchCountriesNetworkError() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)

        let networkError = NSError(domain: "Error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        mockSession.error = networkError

        let result = await withCheckedContinuation { continuation in
            service.fetchCountries { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect((error as NSError).domain == "Error")
            #expect((error as NSError).code == 500)
        }
    }

    @Test("Fetch countries with invalid JSON")
    func fetchCountriesInvalidJSON() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)

        let invalidJsonData = try #require("invalid json".data(using: .utf8))
        mockSession.data = invalidJsonData

        let result = await withCheckedContinuation { continuation in
            service.fetchCountries { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect(error is DecodingError)
        }
    }

    @Test("Fetch countries with empty response")
    func fetchCountriesEmptyResponse() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)

        let emptyArray: [Country] = []
        let jsonData = try JSONEncoder().encode(emptyArray)
        mockSession.data = jsonData

        let result = await withCheckedContinuation { continuation in
            service.fetchCountries { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success(let countries):
            #expect(countries.isEmpty)
        case .failure(let error):
            Issue.record("Expected success but got error: \(error)")
        }
    }

    @Test("Fetch countries with empty data")
    func fetchCountriesEmptyData() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)
        mockSession.data = nil

        let result = await withCheckedContinuation { continuation in
            service.fetchCountries { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            if case URLSessionError.dataIsMissing = error {
                #expect(true)
            } else {
                Issue.record("Expected URLSessionError.dataIsMissing but got \(error)")
            }
        }
    }

    @Test("Fetch country details successfully")
    func fetchCountryDetailsSuccess() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)

        let expectedDetails = [
            CountryDetails(name: CountryName(common: "Germany", official: "Federal Republic of Germany", nativeName: [:]), tld: [], cca2: "DE", independent: true, unMember: true, currencies: [:], capital: [], region: "region", subregion: nil, languages: [:], latlng: [], area: 100, population: 100, timezones: [])
        ]

        let jsonData = try JSONEncoder().encode(expectedDetails)
        mockSession.data = jsonData

        let result = await withCheckedContinuation { continuation in
            service.fetchCountryDetails(code: "DE") { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success(let details):
            #expect(details == expectedDetails)

        case .failure(let error):
            Issue.record("Expected success but got error: \(error)")
        }
    }

    @Test("Fetch country details with network error")
    func fetchCountryDetailsNetworkError() async throws {
        let mockSession = MockURLSession()
        let service = CountriesService(urlSession: mockSession)

        let networkError = NSError(domain: "NetworkError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Country not found"])
        mockSession.error = networkError

        let result = await withCheckedContinuation { continuation in
            service.fetchCountryDetails(code: "INVALID") { result in
                continuation.resume(returning: result)
            }
        }

        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure(let error):
            #expect((error as NSError).domain == "NetworkError")
            #expect((error as NSError).code == 404)
        }
    }
}
