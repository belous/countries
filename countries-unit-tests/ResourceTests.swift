import Testing
import Foundation

@testable import countries

struct TestResource: Codable, Equatable, Sendable {
    let name: String
    let age: Int
}

struct ResourceTests {
    @Test("Resource initializes with custom parse function")
    func testCustomParseFunction() throws {
        let testData = try #require("Hello, World!".data(using: .utf8))

        let customParse: @Sendable (Data) throws -> String = { String(data: $0, encoding: .utf8) ?? "default" }
        let resource = Resource<String>(request: Request(path: "/api/test"), parse: customParse)

        let result = try resource.parse(testData)
        #expect(result == "Hello, World!")
    }

    @Test("Resource custom parse function handles errors")
    func testResourceCustomParseHandlesErrors() throws {
        struct CustomError: Error { }

        let failingParse: @Sendable (Data) throws -> String = { _ in throw CustomError() }
        let resource = Resource<String>(request: Request(path: "/api/test"), parse: failingParse)
        let testData = try #require("test".data(using: .utf8))

        #expect(throws: CustomError.self) {
            try resource.parse(testData)
        }
    }

    @Test("Resource with non-Codable type using custom parser")
    func testNonCodableResource() throws {
        struct NonCodableResource {
            let value: String
        }

        let customParse: @Sendable (Data) throws -> NonCodableResource = {
            NonCodableResource(value: String(data: $0, encoding: .utf8) ?? "")
        }

        let resource = Resource<NonCodableResource>(request: Request(path: "/api/test"), parse: customParse)
        let testData = try #require("custom value".data(using: .utf8))

        let result = try resource.parse(testData)

        #expect(result.value == "custom value")
    }

    @Test("Resource Decodable extension initializes correctly")
    func testDecodableResourceInit() throws {
        let resource = Resource<TestResource>(path: "/api/test")

        let url = try #require(resource.request.urlRequest?.url)

        #expect(url.path == "/api/test")
        #expect(url.query() == "")
    }

    @Test("Resource Decodable extension with query parameters")
    func testDecodableResourceQueryParams() throws {
        let resource = Resource<TestResource>(path: "/api/test", parameters: [URLQueryItem(name: "foo", value: "bar")])

        let url = try #require(resource.request.urlRequest?.url)
        #expect(url.path == "/api/test")

        let query = try #require(url.query())
        #expect(query.contains("foo=bar"))
    }

    @Test("Resource parses valid JSON")
    func testParsingValidJSON() throws {
        let json =
        """
        {
            "name": "Sergei",
            "age": 32
        }
        """

        let resource = Resource<TestResource>(path: "/api/test")
        let jsonData = try #require(json.data(using: .utf8))

        let result = try resource.parse(jsonData)

        #expect(result.name == "Sergei")
        #expect(result.age == 32)
    }

    @Test("Resource handles missing required fields")
    func testMissingRequiredFields() throws {
        let incompleteJSON = """
        {
            "name": "Sergei",
        }
        """

        let resource = Resource<TestResource>(path: "/api/test")
        let jsonData = try #require(incompleteJSON.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try resource.parse(jsonData)
        }
    }

    @Test("Resource handles type mismatches")
    func testTypeMismatch() throws {
        let wrongTypeJSON =
        """
        {
            "name": "Sergei",
            "age": "32",
        }
        """

        let resource = Resource<TestResource>(path: "/api/test")
        let jsonData = try #require(wrongTypeJSON.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try resource.parse(jsonData)
        }
    }

    // MARK: - Array and Collection Tests

    @Test("Resource parses JSON arrays")
    func testParisingJSONArray() throws {
        let jsonArray =
        """
        [
            {
                "name": "Sergei",
                "age": 32
            },
            {
                "name": "Not Sergei",
                "age": 27
            }
        ]
        """

        let resource = Resource<[TestResource]>(path: "/api/test")
        let jsonData = try #require(jsonArray.data(using: .utf8))

        let result = try resource.parse(jsonData)

        #expect(result.count == 2)
        #expect(result[0].name == "Sergei")
        #expect(result[1].name == "Not Sergei")
    }

    @Test("Resource parses empty JSON array")
    func testEmptyJSONArray() throws {
        let emptyArray = "[]"

        let resource = Resource<[TestResource]>(path: "/api/test")
        let jsonData = try #require(emptyArray.data(using: .utf8))

        let result = try resource.parse(jsonData)

        #expect(result.isEmpty)
    }

    @Test("Resource handles empty data")
    func testEmptyData() {
        let resource = Resource<TestResource>(path: "/api/test")
        let emptyData = Data()

        #expect(throws: DecodingError.self) {
            try resource.parse(emptyData)
        }
    }

    @Test("Resource handles invalid JSON")
    func testInvalidJSON() throws {
        let malformedJson = "{ this is not a valid json }"

        let resource = Resource<TestResource>(path: "/api/test")
        let jsonData = try #require(malformedJson.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try resource.parse(jsonData)
        }
    }

    @Test("Resource handles null JSON values")
    func testNullJSONValues() throws {
        let nullJson = """
        {
            "name": null,
            "age": 32
        }
        """

        let resource = Resource<TestResource>(path: "/api/test")
        let jsonData = try #require(nullJson.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try resource.parse(jsonData)
        }
    }
}
