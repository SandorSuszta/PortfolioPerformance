//
//  MarketData.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 17/03/2022.
//

import Foundation

class AllMarketData {
    
    static let shared = AllMarketData()
    
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
