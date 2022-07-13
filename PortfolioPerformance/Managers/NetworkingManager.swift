//
//  NetworkingManager.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 04/07/2022.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    private struct Constants {
        static let requestGreedAndFearIndexBaseUrl = "https://api.alternative.me/fng/"
        static let requestGlobalDataBaseUrl = "https://api.coingecko.com/api/v3/global"
        static let requestAllCryptoCurrenciesDataBaseUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=500&page=1&sparkline=false"
        static let requestDataForListBaseUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids="
        static let requestDataForListTrailingUrl = "&order=market_cap_desc&per_page=100&page=1&sparkline=false"
    }
    
    //MARK: - Generic Request
    private func request<T:Codable>(
        url: URL?,
        expectingType: T.Type,
        completion: @escaping (Result<T,Error>) -> Void
    ){
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(
            with: url) { data, _, error in
                guard let data = data, error == nil  else { fatalError() }
                
                do {
                    let result = try JSONDecoder().decode(expectingType, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        task.resume()
    }
    
    //MARK: - Greed And Fear Index
    public func requestGreedAndFearIndex (
        completion: @escaping (Result<GreedAndFearModel, Error>) -> Void
    ){
        guard let url = URL(string: Constants.requestGreedAndFearIndexBaseUrl) else { fatalError() }
        request(
            url: url,
            expectingType: GreedAndFearModel.self,
            completion: completion
        )
    }
    
    //MARK: - Total Market Cap
    public func requestGlobalData(
        completion: @escaping (Result<GlobalDataResponse, Error>) -> Void
    ){
        guard let url = URL(string: Constants.requestGlobalDataBaseUrl) else { fatalError() }
        request(
            url: url,
            expectingType: GlobalDataResponse.self,
            completion: completion
        )
    }
    
    //MARK: - All Crypto Data
    public func requestCryptoCurrenciesData(
        completion: @escaping (Result<[CoinModel], Error>) -> Void
    ){
        guard let url = URL(string: Constants.requestAllCryptoCurrenciesDataBaseUrl) else { fatalError() }
        request(
            url: url,
            expectingType: [CoinModel].self,
            completion: completion
        )
    }
    
    //MARK: - Crypto Data For Watchlist
    public func requestDataForWatchlist(list: [String], completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        
        let endpoint = constructURLfor(list: list)
        
        guard let url = URL(string: endpoint) else { fatalError() }
        
        request(
            url: url,
            expectingType: [CoinModel].self,
            completion: completion
        )
    }
    
    private func constructURLfor(list: [String]) -> String {
        var updatedBaseURL = NetworkingManager.Constants.requestDataForListBaseUrl

        for coinID in list {
            updatedBaseURL += coinID + "%2C%20"
        }
        
        let endpoint = updatedBaseURL + NetworkingManager.Constants.requestDataForListTrailingUrl
        return endpoint
    }
}
