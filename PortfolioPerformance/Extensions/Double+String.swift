//
//  Double+String.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 19/03/2022.
//

import Foundation

extension Double {
    public func string2f() -> String {
        String(format: "%.2f", self)
    }
}

extension NumberFormatter {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = "+"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let marketCapFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = "+"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension String {
    
    static func priceString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    static func percentageString(from number: Double, positivePrefix: String = "+") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = positivePrefix
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: number / 100)) ?? ""
    }
    
    static func marketCapString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        var formattedNumber: Double = 0
        
        switch number {
        case 1000...999999:
            formatter.positiveSuffix = " K"
            formattedNumber = number / 1000
        case 1000000...999999999:
            formatter.positiveSuffix = " M"
            formattedNumber = number / 1000000
        case 10000000000...999999999999:
            formatter.positiveSuffix = " B"
            formattedNumber = number / 1000000000
        case 999999999999...:
            formatter.positiveSuffix = " T"
            formatter.maximumFractionDigits = 2
            formattedNumber = number / 1000000000000
            
        default:
            formattedNumber = number
        }
        return formatter.string(from: NSNumber(value: formattedNumber)) ?? ""
    }
}

