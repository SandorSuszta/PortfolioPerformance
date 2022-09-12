//
//  MarketCardsCollectionViewViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 30/06/2022.
//

import Foundation

final class MarketCardsCollectionViewViewModel {
   
    var cardViewModels: ObservableObject<[MarketCardsCollectionViewCellViewModel]> = ObservableObject(value: [])
    
    public func loadGreedAndFearIndex() {
        NetworkingManager.shared.requestGreedAndFearIndex { result in
            switch result {
            case .success(let index):
                
                let greedAndFearCardModel = MarketCardCellModel(
                    headerTitle: "GreedAndFear Index",
                    mainTitle: index.data[0].value,
                    secondaryTitle: index.data[0].valueClassification,
                    circularProgressBarType: .gradient,
                    progress: (Float(index.data[0].value) ?? 0)/100,
                    isGrowing: nil
                    )
                
                self.cardViewModels.value?.append(.init(model: greedAndFearCardModel))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func loadGlobalData() {
        NetworkingManager.shared.requestGlobalData { result in
            switch result {
            case .success(let globalDataResponse):
                let totalMarketCap = globalDataResponse.data.totalMarketCap["usd"] ?? 0
                let marketCapChangeFor24H = globalDataResponse.data.marketCapChangePercentage24HUsd
                let allTimeHighMarketCap: Double = 3030000000000
                let btcDominance = globalDataResponse.data.marketCapPercentage["btc"] ?? 0
                
                //Create model for Total Market Cap Card
                let marketCapCardModel = MarketCardCellModel(
                    headerTitle: "Total Market Cap",
                    mainTitle: .bigNumberString(from: totalMarketCap),
                    secondaryTitle: .percentageString(from: marketCapChangeFor24H),
                    circularProgressBarType: .round,
                    progress: Float(totalMarketCap / allTimeHighMarketCap),
                    isGrowing: globalDataResponse.data.marketCapChangePercentage24HUsd >= 0 
                )
                
                //Create model for BTC Dominance Card
                let dominanceCardModel = MarketCardCellModel(
                    headerTitle: "Bitcoin Dominance",
                    mainTitle: .percentageString(from: btcDominance, positivePrefix: ""),
                    secondaryTitle: "",
                    circularProgressBarType: .round,
                    progress: Float(btcDominance / 100),
                    isGrowing: true
                )
                
                //Add card view models to the observable array
                self.cardViewModels.value?.append(.init(model: marketCapCardModel))
                self.cardViewModels.value?.append(.init(model: dominanceCardModel))
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
