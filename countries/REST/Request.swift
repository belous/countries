import Foundation

struct Request {
    static let Decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let scheme = "https"
    private let hostname = "restcountries.com"
    private let httpMethod = "GET"

    let urlRequest: URLRequest?

    init(path: String, parameters queryItems: [URLQueryItem] = []) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = hostname
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            self.urlRequest = urlRequest
        } else {
            self.urlRequest = nil
        }
    }
}
