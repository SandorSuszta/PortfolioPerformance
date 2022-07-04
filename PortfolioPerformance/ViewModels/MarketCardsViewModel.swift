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
        NetworkingManager.shared.getGreedAndFearIndex { result in
            switch result {
            case .success(let index):
                let cardModel = MarketCardCellModel(
                    headerTitle: "GreedAndFear Index",
                    mainTitle: index.data[0].value,
                    secondaryTitle: "Extreme Fear",
                    circularProgressBarType: .gradient,
                    progress: (Float(index.data[0].value) ?? 0)/100)
                
                self.cardViewModels.value?.append(.init(model: cardModel))
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
