import Foundation

protocol MarketService {
    func getCryptoCurrenciesData(completion: @escaping (Result<[CoinModel], Error>) -> Void)
    func getGlobalData(completion: @escaping (Result<GlobalDataResponse, Error>) -> Void)
}
