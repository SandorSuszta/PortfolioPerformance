//
//  WatchlistTableViewViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 11/07/2022.
//

import Foundation

class WatchlistTableViewModel {
    
    var cellViewModels: ObservableObject<[MarketTableCellViewModel]> = ObservableObject(value:[])
    
    public func loadWatchlistCryptoCurrenciesData() {
        NetworkingManager.shared.requestDataForWatchlist(list: PersistanceManager.shared.watchlistIDs) { result in
            
            switch result {
            case .success(let coinModels):
                //Transform array of coin models into array of cell view models
                self.cellViewModels.value = coinModels.compactMap({ .init(coinModel: $0)
                })
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
}
