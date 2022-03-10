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
        static let getMarketDataEndpoint  = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"
        static let getGreedAndFearIndexEndpoint = "https://api.alternative.me/fng/"
    }
    
    public func getMarketData(
        completion: @escaping (Result<[CoinModel], Error>) -> Void
    ) {
        guard let url = URL(string: Constants.getMarketDataEndpoint) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else { return }
            
                do {
                    let coinArray = try JSONDecoder().decode([CoinModel].self, from: data)
                    completion(.success(coinArray))
                } catch {
                    completion(.failure(error))
                    
            }
        }
        task.resume()
    }
    
    public func getGreedAndFearIndex(
        completion: @escaping (Result<GreedAndFearModel, Error>) -> Void
    ) {
        guard let url = URL(string: Constants.getGreedAndFearIndexEndpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {return}
            
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
}

