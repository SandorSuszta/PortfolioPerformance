//
//  UIProgressView+Height.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 27/05/2022.
//

import Foundation
import UIKit

// Change height of progress bar, setting custom height

class CustomProgressView: UIProgressView {
    
    var customHeight: CGFloat = 1.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size: CGSize = .init(width: size.width, height: customHeight)
        return size
    }
    
    
    
}
