//
//  MarketCardViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 27/06/2022.
//

import Foundation
import UIKit

class MarketCardsCollectionViewCellViewModel {
    
    var model: MarketCardCellModel
    
    var headerTitle: String {
        model.headerTitle
    }
    
    var mainTitle: String {
        model.mainTitle
    }
    
    var secondaryTitle: String {
        model.secondaryTitle
    }
    
    var progressValue: Float {
        model.progress
    }
    
    var progressCircleType: CircularProgressBarType {
        model.circularProgressBarType
    }
    
    var changeColour: UIColor {
        if let value = Float(model.secondaryTitle) {
            return value > 0 ? .nephritis : .pomergranate
        } else {
            return .clouds
        }
    }
    
    init (model: MarketCardCellModel) {
        self.model = model
    }
    
}
