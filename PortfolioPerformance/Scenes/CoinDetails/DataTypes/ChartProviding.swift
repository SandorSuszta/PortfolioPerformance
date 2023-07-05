//
//  ChartProviding.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 05/07/2023.
//

import UIKit

protocol ChartProviding {
    associatedtype DataType
    
    func setData(_ data: DataType)
    
    func setChartColor(_ color: UIColor)
}
