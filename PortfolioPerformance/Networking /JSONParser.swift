import Foundation

final class JSONParser: JSONParserProtocol {
    func parse<T>(_ type: T.Type, from data: Data, response: URLResponse?) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
