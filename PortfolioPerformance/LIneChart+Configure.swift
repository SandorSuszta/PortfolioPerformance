//
//  LIneChart+Configure.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 20/04/2022.
//

import Foundation
import Charts

extension LineChartDataSet {
    
    self.drawCirclesEnabled = false // Disable data points
    self.mode = .horizontalBezier
    self.lineWidth = 2
    self.cubicIntensity = 0.01
    self.drawHorizontalHighlightIndicatorEnabled = false
    self.highlightEnabled = false
    self.highlightLineWidth = 3
    self.setColor(.nephritis)
    
}
