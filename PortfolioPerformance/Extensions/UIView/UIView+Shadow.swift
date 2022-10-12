//
//  File.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 30/03/2022.
//

import Foundation
import UIKit

extension UIView {
    
    public func configureWithShadow(
        shadowColor: UIColor = .systemGray3,
        shadowRadius: CGFloat = 2.0
    ){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = shadowRadius
    }
}
