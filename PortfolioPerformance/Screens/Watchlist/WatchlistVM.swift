//
//  WatchlistTableViewViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 11/07/2022.
//

import Foundation

class WatchlistViewModel {
    
    public var cellViewModels: ObservableObject<[MarketTableCellViewModel]> = ObservableObject(value:[])
    
    public var errorMessage: ObservableObject<String>?
    
    public func loadWatchlistCryptoCurrenciesData(list: [String]) {
        
        NetworkingManager.shared.requestDataForWatchlist(list: list) { result in
            switch result {
            case .success(let coinModels):
                //Transform array of coin models into array of cell view models
                let viewModels: [MarketTableCellViewModel] = coinModels.compactMap({ .init(coinModel: $0)
                })
                self.cellViewModels.value = viewModels
               
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}
