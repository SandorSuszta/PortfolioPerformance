//
//  APICaller.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import Foundation

class APICaller {
    
    static let shared = APICaller()
    
    private struct Constants {
        static let getMarketDataEndpoint  = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=500&page=1&sparkline=false"
        static let getGreedAndFearIndexEndpoint = "https://api.alternative.me/fng/"
        static let getGlobalDataEndpoint = "https://api.coingecko.com/api/v3/global"
        static let searchEndpoint = "https://api.coingecko.com/api/v3/search?query="
    }
    
    // MARK: - Get Market Data
    
    public func getMarketData(
        completion: @escaping (Result<[CoinModel], Error>) -> Void
    ) {
        guard let url = URL(string: Constants.getMarketDataEndpoint) else { fatalError() }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data = data,
                error == nil
            else { return }
            
            do {
                let coinArray = try JSONDecoder().decode([CoinModel].self, from: data)
                completion(.success(coinArray))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Get Price On A Given Date
    
    public func getPriceOnGivenDate(
        for coinID: String,
        on date: String,
        completion: @escaping (Result<Double, Error>) -> Void
    ){
        let endpoint = "https://api.coingecko.com/api/v3/coins/\(coinID)/history?date=\(date)"
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  error == nil
            else { return }
            
            do {
                let coinPrice = try JSONDecoder().decode(CoinPriceOnGivenDate.self, from: data)
                guard let price = coinPrice.market_data.current_price["usd"] else { fatalError()}
                completion(.success(price))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Get Greed And Fear Index
    
    public func getGreedAndFearIndex(
        completion: @escaping (Result<GreedAndFearModel, Error>) -> Void
    ){
        guard let url = URL(string: Constants.getGreedAndFearIndexEndpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { fatalError() }
            
            do {
                let index = try
                JSONDecoder().decode(GreedAndFearModel.self, from: data)
                completion(.success(index))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Get Global Data
    
    public func getGlobalData (
        completion: @escaping (Result<GlobalData, Error>) -> Void
    ){
        guard let url = URL(string: Constants.getGlobalDataEndpoint) else { fatalError() }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { fatalError() }
            
            do {
                let globalDataResponse = try JSONDecoder().decode(GlobalDataResponse.self, from: data)
                let globalData = globalDataResponse.data
                completion(.success(globalData))
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Graph Entries
    public func getHistoricalPrices(
        for coinID: String,
        intervalInDays: Int,
        completion: @escaping (Result<GraphEntries, Error>) -> Void
    ){
        
        let unixTimeNow = Int(Date().timeIntervalSince1970)
        let unixTimeThen = unixTimeNow - (86400 * intervalInDays)
        
        let endPoint = "https://api.coingecko.com/api/v3/coins/\(coinID)/market_chart/range?vs_currency=usd&from=\(unixTimeThen)&to=\(unixTimeNow)"
        
        guard let url = URL(string: endPoint) else { fatalError("Wrong url")}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { fatalError() }
            
            do {
                let entries = try JSONDecoder().decode(GraphEntries.self, from: data)
                completion(.success(entries))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func searchForCoin(
        query: String,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ){
        guard let url = URL(string: Constants.searchEndpoint + query) else { fatalError() }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else { fatalError() }
            
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
