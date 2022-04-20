//
//  Date+FormatedString.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 19/03/2022.
//

import Foundation

// TODO: New Date Formatter IOS15 - https://sarunw.com/posts/new-formatters-in-ios15/

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
    
    func stringForGraph(forDays days:Int) -> String {
        let df = DateFormatter()
        
        switch days {
        case 1:
            df.dateFormat = "HH:mm"
        case 7, 30:
            df.dateFormat = "d MMM"
        case 180, 360:
            df.dateFormat = "MMM yy"
        case 2000:
            df.dateFormat = "yyyy"
        default: fatalError()
        }
        
        return df.string(from: self)
    }
}
