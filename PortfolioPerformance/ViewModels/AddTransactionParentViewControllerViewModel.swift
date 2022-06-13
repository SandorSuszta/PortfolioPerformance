//
//  AddTransactionParentViewControllerVIewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 30/05/2022.
//

import Foundation
import UIKit

struct AddTransactionParentViewControllerViewModel {
    
    let coinModel: CoinModel
    
    let coinName: String
    
    let coinSymbol: String
    
    let tradingPair: String
    
    let coinLogoData: Data?
    
    let coinLogoUrl: String
    
    
    init(coinModel: CoinModel) {
        self.coinModel = coinModel
        self.coinName = coinModel.name
        self.coinSymbol = coinModel.symbol.uppercased()
        self.tradingPair = "USDT"
        self.coinLogoData = coinModel.imageData
        self.coinLogoUrl = coinModel.image
    }
    
}
