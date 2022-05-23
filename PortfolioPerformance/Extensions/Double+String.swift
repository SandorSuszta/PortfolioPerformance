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
