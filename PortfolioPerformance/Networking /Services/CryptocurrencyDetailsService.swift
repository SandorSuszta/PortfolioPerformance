import Foundation

struct CryptocurrencyDetailsService: CryptocurrencyDetailsServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    // MARK: - API
    
    func getChartData(for ID: String,
                      inDaysInterval interval: Int,
                      completion: @escaping (Result<PriceModels, Error>) -> Void) {
        
        httpClient.performRequest(url: CryptoEndpoint.getChartData(ID: ID, daysInterval: interval).url,
                                  responseType: PriceModels.self,
                                  completionHandler: completion)
    }
    
    func getDetailsData(for ID: String,
                        completion: @escaping (Result<CoinDetails, Error>) -> Void) {
        
        httpClient.performRequest(url: CryptoEndpoint.getDetailsData(ID: ID).url,
                                  responseType: CoinDetails.self,
                                  completionHandler: completion)
    }
}
