//
//  MarketData.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 17/03/2022.
//

import Foundation

class MarketData {
    
    static var allCoinsArray: [CoinModel] = []
    
    static func getMarketData() {
        
        APICaller.shared.getMarketData { result in
            switch result {
                
            case .success(let coinArray):
                MarketData.allCoinsArray = coinArray
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
