//
//  EmptyStateView.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 31/10/2022.
//

import UIKit

class EmptyStateView: UIView {
    
    //MARK: - Properties
    
    private let imageView: UIImageView
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    
    init(text: String, imageName: String) {
        
        imageView = UIImageView(image: UIImage(named: imageName))
        textLabel.text = text
        super .init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(imageView, textLabel)
        isHidden = true
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 1.5),
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 1.5),
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
}
