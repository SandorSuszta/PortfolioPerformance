import Foundation

struct CryptocurrencyMarketService: CryptocurrencyMarketServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    // MARK: - API
    
    func getCryptoCurrenciesData(completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        httpClient.performRequest(url: CryptoEndpoint.getAllCryptoData.url,
                                  responseType: [CoinModel].self,
                                  completionHandler: completion)
    }
    
    func getGlobalData(completion: @escaping (Result<GlobalDataResponse, Error>) -> Void) {
        httpClient.performRequest(url: CryptoEndpoint.getGlobalData.url,
                                  responseType: GlobalDataResponse.self,
                                  completionHandler: completion)
    }
}
