import Foundation

protocol HTTPClientProtocol {
    
    func performRequest<T: Decodable>(url: URL?, responseType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void)
    
    func cancelRequest()
}
