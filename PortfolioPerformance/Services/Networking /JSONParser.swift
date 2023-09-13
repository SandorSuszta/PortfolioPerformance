import Foundation

protocol JSONParser {
    func parse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
