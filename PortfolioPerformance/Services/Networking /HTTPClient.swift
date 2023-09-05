import Foundation

protocol HTTPClient {
    func performRequest<T: APIRequest>(_ request: T) async throws -> T.ResponseType
}

protocol APIRequest {
    associatedtype ResponseType: Decodable
    
    var endpoint: Endpoint { get }
}

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters
        
        return components.url
    }
}

