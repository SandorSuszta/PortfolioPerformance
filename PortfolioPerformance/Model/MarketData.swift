//
//  MarketData.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 17/03/2022.
//

import Foundation

class MarketData {
    
    static let shared = MarketData()
    
    public var allCoinsArray: [CoinModel] = []
    
    public func getMarketData() {
        
        APICaller.shared.getMarketData { result in
            switch result {
                
            case .success(let coinArray):
                self.allCoinsArray = coinArray
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
