import Foundation

struct Resource<T>: Sendable {
    let request: Request
    let parse: @Sendable (Data) throws -> T
}

extension Resource where T: Decodable {
    init(path: String, parameters queryItems: [URLQueryItem] = []) {
        self.request = Request(path: path, parameters: queryItems)
        self.parse = { data in
            try Request.Decoder.decode(T.self, from: data)
        }
    }
}
