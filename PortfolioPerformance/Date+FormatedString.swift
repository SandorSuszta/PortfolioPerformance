//
//  Date+FormatedString.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 19/03/2022.
//

import Foundation

extension Date {
    
    func formatedString() -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: self)
    }
    
    func stringForAPI() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df.string(from: self)
    }
}
