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
        shadowColor: UIColor = .systemGray5,
        shadowRadius: CGFloat = 5.0
    ){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = shadowRadius
    }
}
