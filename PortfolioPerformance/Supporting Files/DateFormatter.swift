//
//  DateFormatter.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 15/03/2022.
//

import UIKit
import Foundation

struct Formatter {
    static func formatDate(from date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
    
    
}
