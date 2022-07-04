//
//  HoldingsTableViewCellViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 25/05/2022.
//

import Foundation

struct HoldingsTableViewCellViewModel {
    
    let holdingPerfomanceModel: HoldingPerfomanceModel
    
    let portfolioValue: Double
    
    var coinName: String {
        holdingPerfomanceModel.coinModel.name
    }
    
    var coinSymbol: String {
        holdingPerfomanceModel.coinModel.symbol.uppercased()
    }
    
    var imageUrl: String {
        holdingPerfomanceModel.coinModel.image
    }
    
    var imageData: Data? {
        holdingPerfomanceModel.coinModel.imageData
    }
    
    var currentPrice: String {
        holdingPerfomanceModel.coinModel.currentPrice.string2f()
    }
    
    var holdings: String {
        holdingPerfomanceModel.holdingModel.ammount.string2f()
    }
    
    var averageBuyingPrice: String {
        (holdingPerfomanceModel.holdingModel.totalCostBasis/(holdingPerfomanceModel.holdingModel.ammount - holdingPerfomanceModel.holdingModel.ammountTransferred )).string2f()
    }
    
    var unrealizedGains: String {
        holdingPerfomanceModel.unrealizedGainsOrLosses.string2f()
    }
    
    var realizedGains: String {
        holdingPerfomanceModel.holdingModel.realizedGainsOrLosses.string2f()
    }
    
    // Gains from stacking etc
    var rewardsValue: String {
        holdingPerfomanceModel.rewardsValue.string2f()
    }
    
    var holdingsValue: String {
        holdingPerfomanceModel.holdingValue.string2f()
    }
    
    var holdingsValueChange: String {
        holdingPerfomanceModel.holdingValueChange.string2f()
    }
    
    var holdingsValueChangePercentage: String {
        "(" + holdingPerfomanceModel.holdingValueChangePercentage.string2f() + "%)"
    }
    
    var holdingsPortfolioAllocation: String {
        (holdingPerfomanceModel.holdingValue / portfolioValue * 100).string2f() + "%"
    }
    
    var holdingPortfolioAllocation: Float {
        Float(holdingPerfomanceModel.holdingValue / portfolioValue)
    }
    
    var isProfit: Bool {
        holdingPerfomanceModel.holdingValueChange >= 0 ? true : false
    }
    
}
