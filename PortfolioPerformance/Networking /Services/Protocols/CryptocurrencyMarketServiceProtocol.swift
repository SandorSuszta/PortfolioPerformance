import Foundation

protocol CryptocurrencyMarketServiceProtocol {
    func getCryptoCurrenciesData(completion: @escaping (Result<[CoinModel], Error>) -> Void)
    func getGlobalData(completion: @escaping (Result<GlobalDataResponse, Error>) -> Void)
}
