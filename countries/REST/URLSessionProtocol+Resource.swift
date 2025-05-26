import Foundation

extension URLSessionProtocol {
    func load<T>(_ resource: Resource<T>, completionHandler: @escaping @Sendable (Result<T, Error>) -> Void) {
        guard let urlRequest = resource.request.urlRequest else {
            completionHandler(.failure(URLSessionError.invalidURL))
            return
        }
        dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(URLSessionError.dataIsMissing))
                return
            }
            do {
                let value = try resource.parse(data)
                completionHandler(.success(value))
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
