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
        static let endpoint  = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"
    }
    
    public func getMarketData(
        completion: @escaping (Result<[CoinModel], Error>) -> Void
    ) {
        guard let url = URL(string: Constants.endpoint) else {
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
}


