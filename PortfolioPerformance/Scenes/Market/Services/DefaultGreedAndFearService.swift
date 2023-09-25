import Foundation

struct DefaultGreedAndFearService: GreedAndFearService {
    private let httpClient: HTTPClient
    
    // MARK: - API
    
    func getGreedAndFearData(completion: @escaping (Result<GreedAndFearResponse, Error>) -> Void) {
        httpClient.performRequest(
            url: CryptoEndpoint.getGreedAndFear.url,
            responseType: GreedAndFearResponse.self,
            completionHandler: completion
        )
    }
}
