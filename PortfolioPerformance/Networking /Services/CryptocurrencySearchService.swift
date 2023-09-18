import Foundation

struct CryptocurrencySearchService: SearchCryptocurrencyServiceProtocol {
    private let httpClient: HTTPClient
    
    // MARK: - API
    
    func searchWith(query: String,
                    completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        
        httpClient.performRequest(url: CryptoEndpoint.search(query: query).url,
                                  responseType: SearchResponse.self,
                                  completionHandler: completion)

    }
    
    func getTrendingCoins(completion: @escaping (Result<TrendingResponse, Error>) -> Void) {
        
        httpClient.performRequest(url: CryptoEndpoint.getTrendingCrypto.url,
                                  responseType: TrendingResponse.self,
                                  completionHandler: completion)
    }
}
