//
//  PPButton.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 06/10/2022.
//

import UIKit

class PPButton: UIButton {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, name: String) {
        super .init(frame: .zero)
        backgroundColor = color
        setTitle(name, for: .normal)
        setup()
    }
    
    //MARK: - Private methods
    
    private func setup() {
        layer.cornerRadius = 16
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
