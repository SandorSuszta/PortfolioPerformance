import Foundation

final class HTTPClient: HTTPClientProtocol {
    func performRequest<T>(url: URL?, responseModel: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        <#code#>
    }
    
    
    func performRequest(url: URL?, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url else {
            completionHandler(.failure(PPError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(
            with: url) { data, _, error in
                
                guard let data = data, error == nil  else {
                    completionHandler(.failure(PPError.netwokingError))
                    return
                }
                
                completionHandler(.success(data))
            }
        task.resume()
    }
}
