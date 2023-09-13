import Foundation

protocol HTTPClientProtocol {
    func performRequest<T: Decodable>(url: URL?, responseModel: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void)
}
