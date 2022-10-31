//
//  MarketViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 06/10/2022.
//

import Foundation

class MarketViewModel {
    
    public var cardViewModels: ObservableObject<[MarketCardsCollectionViewCellViewModel]> = ObservableObject(value: [])
    
    public var cellViewModels: ObservableObject<[MarketTableCellViewModel]> = ObservableObject(value:[])
    
    public var errorMessage: ObservableObject<String>?
    
    public let sortOptionsArray = ["Highest Cap", "Top Winners", "Top Losers", "Top Volume"]
    
    //MARK: - Init
    
    init() {
        loadGreedAndFearIndex()
        loadGlobalData()
        loadAllCryptoCurrenciesData()
    }
    
    //MARK: - Public methods
    
    public func loadGreedAndFearIndex() {
        NetworkingManager.shared.requestGreedAndFearIndex { result in
            switch result {
            case .success(let index):
                
                let greedAndFearCellViewModel = MarketCardsCollectionViewCellViewModel(
                    metricName: "Greed And Fear Index",
                    mainMetricValue: index.data[0].value,
                    secondaryMetricValue: index.data[0].valueClassification,
                    progressValue: (Float(index.data[0].value) ?? 0)/100,
                    progressCircleType: .gradient)
                
                self.cardViewModels.value?.append(greedAndFearCellViewModel)
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
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
                let marketCapCellViewModel = MarketCardsCollectionViewCellViewModel(
                    metricName: "Total Market Cap",
                    mainMetricValue: .bigNumberString(from: totalMarketCap),
                    secondaryMetricValue: .percentageString(from: marketCapChangeFor24H),
                    progressValue: Float(totalMarketCap / allTimeHighMarketCap),
                    progressCircleType: .round)
                
                //Create model for BTC Dominance Card
                let dominanceCardModel = MarketCardsCollectionViewCellViewModel(
                    metricName: "Bitcoin Dominance",
                    mainMetricValue: .percentageString(from: btcDominance, positivePrefix: ""),
                    secondaryMetricValue: "",
                    progressValue: Float(btcDominance / 100),
                    progressCircleType: .round)
                
                //Add card view models to the observable array
                self.cardViewModels.value?.append(contentsOf: [marketCapCellViewModel,dominanceCardModel])
                
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    public func loadAllCryptoCurrenciesData() {
        NetworkingManager.shared.requestCryptoCurrenciesData { result in
            
            switch result {
            case .success(let cryptosArray):
                //Transform array of coin models into array of cell view models
                self.cellViewModels.value = cryptosArray.compactMap({ .init(coinModel: $0) })
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}
