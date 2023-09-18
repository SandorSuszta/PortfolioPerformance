import Foundation

struct CryptocurrencyListService: CryptocurrencyListServiceProtocol {
    private let httpClient: HTTPClient
    
    // MARK: - API
    
    func getDataFor(IDs: [String],
                    completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        
        httpClient.performRequest(url: CryptoEndpoint.getDataForList(IDs: IDs).url,
                                  responseType: [CoinModel].self,
                                  completionHandler: completion)
    }
}
