//
//  PortfolioPerfomanceModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 25/05/2022.
//

struct PortfolioPerfomanceModel {
    
    let holdingPerfomanceModels: [HoldingPerfomanceModel]
    
    var portfolioValue: Double {
        holdingPerfomanceModels.reduce(0) { $0 + $1.holdingValue}
    }
    
    var rewardsValue: Double {
        holdingPerfomanceModels.reduce(0) { $0 + $1.rewardsValue}
    }
    
    var realizedGainsOrLosses: Double {
        holdingPerfomanceModels.reduce(0) { $0 + $1.holdingModel.realizedGainsOrLosses}
    }
    
    var unrealizedGainsOrLosses: Double {
        holdingPerfomanceModels.reduce(0) { $0 + $1.unrealizedGainsOrLosses}
    }
    
    var totalBasisCost: Double {
        holdingPerfomanceModels.reduce(0) { $0 + $1.holdingModel.totalCostBasis}
    }
    
    var totalGainsOrLosses: Double {
       portfolioValue + realizedGainsOrLosses + rewardsValue - totalBasisCost
    }
    
    var totalGainsOrLossesPercentage: Double {
        totalGainsOrLosses / totalBasisCost * 100
    }
    
}

