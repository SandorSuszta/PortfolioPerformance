import Foundation

final class HTTPClient: HTTPClientProtocol {
    private let parser: JSONParserProtocol
    
    // MARK: - Init
    
    init(parser: JSONParserProtocol) {
        self.parser = parser
    }
    
    // MARK: - API

    func performRequest<T: Decodable>(url: URL?, responseType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url else {
            completionHandler(.failure(PPError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil  else {
                completionHandler(.failure(PPError.netwokingError))
                return
            }
            
            do {
                let model = try self.parser.parse(responseType, from: data, response: response)
                completionHandler(.success(model))
            } catch {
                completionHandler(.failure(PPError.decodingError))
            }
        }
    }
}
