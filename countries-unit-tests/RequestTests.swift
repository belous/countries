import Testing
import Foundation

@testable import countries

struct RequestTests {

    @Test("JSONDecoder is a static single instance")
    func testDecoderIsStaticSingleInstance() {
        let decoder1 = Request.Decoder
        let decoder2 = Request.Decoder
        #expect(decoder1 === decoder2)
    }

    @Test("JSONDecoder is configured to snake_case decoding strategy")
    func testDecoderConfiguredForSnakeCase() {
        let decoder = Request.Decoder
        if case .convertFromSnakeCase = decoder.keyDecodingStrategy {
            #expect(true)
        } else {
            Issue.record("Expected .convertFromSnakeCase decoding strategy")
        }
    }

    @Test("Request initializes with simple path")
    func testInitWithSimplePath() throws {
        let request = Request(path: "/simple/path")

        let urlRequest = try #require(request.urlRequest)
        #expect(urlRequest.httpMethod == "GET")
        let url = try #require(urlRequest.url)
        #expect(url.scheme == "https")
        #expect(url.host == "restcountries.com")
        #expect(url.path == "/simple/path")
    }

    @Test("Request initializes with empty path")
    func testInitWithEmptyPath() throws {
        let request = Request(path: "")

        let url = try #require(request.urlRequest?.url)
        #expect(url.path == "")
    }

    @Test("Request initializes with single query parameter")
    func testInitWithSingleQueryParameter() throws {
        let request = Request(path: "/", parameters: [URLQueryItem(name: "foo", value: "bar")])

        let query = try #require(request.urlRequest?.url?.query())
        #expect(query.contains("foo=bar"))
    }

    @Test("Request initializes with several query parameter")
    func testInitWithSeveralQueryParameters() throws {
        let request = Request(path: "/", parameters: [
            URLQueryItem(name: "foo", value: "bar"),
            URLQueryItem(name: "abc", value: "123"),
        ])

        let query = try #require(request.urlRequest?.url?.query())
        #expect(query.contains("foo=bar"))
        #expect(query.contains("abc=123"))
    }


    @Test("Request initilized with invalid path")
    func testInitWithInvalidPath() {
        let request = Request(path: "api")
        #expect(request.urlRequest == nil)
    }
}
