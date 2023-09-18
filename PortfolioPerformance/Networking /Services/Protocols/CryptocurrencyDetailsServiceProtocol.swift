import Foundation

protocol CryptocurrencyDetailsServiceProtocol {
    
    func getChartData(for ID: String,
                      inDaysInterval interval: Int,
                      completion: @escaping (Result<PriceModels, Error>) -> Void)
    
    func getDetailsData(for ID: String,
                        completion: @escaping (Result<CoinDetails, Error>) -> Void)
}
