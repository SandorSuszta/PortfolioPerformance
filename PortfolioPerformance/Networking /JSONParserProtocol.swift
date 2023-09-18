import Foundation

protocol JSONParserProtocol {
    func parse<T: Decodable>(_ type: T.Type, from data: Data, response: URLResponse?) throws -> T
}
