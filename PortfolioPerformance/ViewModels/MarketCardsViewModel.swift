//
//  MarketCardsCollectionViewViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 30/06/2022.
//

import Foundation

final class MarketCardsCollectionViewViewModel {
    
    var totalMarketCapCardModel: MarketCardCellModel
    var bitcoinDominanceCardModel: MarketCardCellModel?
    var greedAndFearCardModel: MarketCardCellModel?
   
    var cardModels: ObservableObject<[MarketCardCellModel]> {
        .init(value: [
            totalMarketCapCardModel,
            bitcoinDominanceCardModel,
            greedAndFearCardModel
        ])}
    
    public func loadGreedAndFearIndex() {
        APICaller.shared.getGreedAndFearIndex { result in
            switch result {
            case .success(let index):
                self.cardModels.value?[2] = MarketCardCellModel(
                    headerTitle: "",
                    mainTitle: "",
                    secondaryTitle: "",
                    circularProgressBarType: .gradient, 
                    progress: Float(index.data[0].value) ?? 0.0
                )
            case .failure(let error):
                print(error)
            }
        }
    }
}
