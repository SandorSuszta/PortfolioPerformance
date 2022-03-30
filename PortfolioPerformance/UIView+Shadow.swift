//
//  File.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 30/03/2022.
//

import Foundation
import UIKit

extension UIView {
    
    func configureWithShadow(
        shadowColor: UIColor = .lightGray,
        shadowRadius: CGFloat = 5.0
    ){
        self.layer.cornerRadius = 15
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = shadowRadius
    }
}
