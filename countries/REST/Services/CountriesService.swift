import Foundation

final class CountriesService: Sendable {

    let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchCountries(completion: @escaping @Sendable (Result<[Country], Error>) -> Void) {
        let parameters = [URLQueryItem(name: "fields", value: "name,cca2,flag")]
        let resource = Resource<[Country]>(path: "/v3.1/all", parameters: parameters)
        urlSession.load(resource, completionHandler: completion)
    }

    func fetchCountryDetails(code: String, completion: @escaping @Sendable (Result<[CountryDetails], Error>) -> Void) {
        let resource = Resource<[CountryDetails]>(path: "/v3.1/alpha/" + code)
        urlSession.load(resource, completionHandler: completion)
    }
}
