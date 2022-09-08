//
//  HoldingPerfomanceModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 25/05/2022.
//

import Foundation

struct HoldingPerfomanceModel {
    
    let holdingModel: HoldingModel
    
    let coinModel: CoinModel
    
    var unrealizedGainsOrLosses: Double {
        let ammountBought = holdingModel.ammount - holdingModel.ammountTransferred
        let gains = holdingModel.totalCostBasis - ammountBought * coinModel.currentPrice
        return gains
    }
    
    // Gains from stacking etc
    var rewardsValue: Double {
        let value = holdingModel.ammountTransferred * coinModel.currentPrice
        return value
    }
    
    var holdingValue: Double {
        let value = holdingModel.ammount * coinModel.currentPrice
        return value
    }
    
    var holdingValueChange: Double {
        let invested = holdingModel.totalCostBasis
        let rewards = holdingModel.ammountTransferred * coinModel.currentPrice
        let currentValueOfBoughtCoins = (holdingModel.ammount - holdingModel.ammountTransferred) * coinModel.currentPrice
        let realized = holdingModel.realizedGainsOrLosses
        let change = currentValueOfBoughtCoins + rewards + realized - invested
        return change
    }
    
    var holdingValueChangePercentage: Double {
        holdingValueChange / holdingModel.totalCostBasis * 100
    }
}
