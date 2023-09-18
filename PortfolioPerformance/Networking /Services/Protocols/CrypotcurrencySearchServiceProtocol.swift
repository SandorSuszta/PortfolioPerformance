import Foundation

protocol SearchCryptocurrencyServiceProtocol {
    
    func searchWith(query: String,
                    completion: @escaping (Result<SearchResponse, Error>) -> Void)
    
    func getTrendingCoins(completion: @escaping (Result<TrendingResponse, Error>) -> Void)
}
