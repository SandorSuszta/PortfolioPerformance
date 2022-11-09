//
//  MarketCardViewModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 27/06/2022.
//

import Foundation
import UIKit

struct MarketCardCellViewModel {
    
    var metricName: String
    
    var mainMetricValue: String
    
    var secondaryMetricValue: String
    
    var progressValue: Float
    
    var progressBarType: CircularProgressBarType
    
    var isChangePositive: Bool? = nil
    
    var secondaryMetricTextColor: UIColor {
        switch progressBarType {
        case .round:
            return isChangePositive ?? true ? .nephritis : .pomergranate
        case .gradient:
            return determineColorBasedOn(indexValue: Int(mainMetricValue) ?? 0)
        }
    }
    
    private func determineColorBasedOn(indexValue: Int) -> UIColor {
        
        switch indexValue {
        case 0...20:
            return .pomergranate
        case 21...40:
            return .alizarin
        case 41...54:
            return .carrot
        case 55...74:
            return .emerald
        case 75...100:
            return .nephritis
        default:
            return .clear
        }
    }
}
