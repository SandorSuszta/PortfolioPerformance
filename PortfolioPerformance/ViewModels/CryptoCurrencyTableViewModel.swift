//
//  CryptoCurrencyTableViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 07/07/2022.
//

import Foundation

class CryptoCurrencyTableViewModel {
    
    public var cellViewModels: ObservableObject<[MarketTableCellViewModel]> = ObservableObject(value:[])
    
    public func loadAllCryptoCurrenciesData() {
        NetworkingManager.shared.requestCryptoCurrenciesData { result in
            
            switch result {
            case .success(let cryptosArray):
                //Transform array of coin models into array of cell view models
                self.cellViewModels.value = cryptosArray.compactMap({ .init(coinModel: $0) })
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
}
