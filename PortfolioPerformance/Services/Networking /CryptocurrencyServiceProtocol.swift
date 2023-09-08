import Foundation

protocol CryptocurrencyServiceProtocol {
    var httpClient: HTTPClient { get }
    
    func getCryptoCurrenciesData(completion: @escaping (Result<[CoinModel], Error>) -> Void)
    func getGlobalData(completion: @escaping (Result<GlobalDataResponse, Error>) -> Void)
    func getDataFor(IDs: [String], completion: @escaping (Result<[CoinModel], Error>) -> Void)
    func getChartData(for ID: String, inDaysInterval interval: Int, completion: @escaping (Result<PriceModels, Error>) -> Void)
    func getDetailsData(for ID: String, completion: @escaping (Result<CoinDetails, Error>) -> Void)
    func searchWith(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void)
    func getTrendingCoins(completion: @escaping (Result<TrendingResponse, Error>) -> Void)
}
