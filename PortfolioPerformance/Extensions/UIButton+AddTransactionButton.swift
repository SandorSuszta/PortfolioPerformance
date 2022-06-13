//
//  UIButton+AddTransactionButton.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 10/06/2022.
//

import Foundation
import UIKit

class AddTransactionButton: UIButton {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        setTitle("Add Transaction", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        backgroundColor = color
        layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
