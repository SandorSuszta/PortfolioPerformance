//
//  SortOptionsCollectionViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 07/07/2022.
//

import Foundation
import UIKit

class SortOptionsCell: UICollectionViewCell {
    
    static let identifier = "SortOptionCell"
    static let preferredHeight: CGFloat = 20
    static let preferredWidth: CGFloat = 90
    
    public var sortingNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            sortingNameLabel.textColor = isSelected ? .PPblue : .systemGray
            sortingNameLabel.font = isSelected ? .systemFont(ofSize: 13, weight: .medium) : .systemFont(ofSize: 12, weight: .regular)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        sortingNameLabel.frame = contentView.bounds
        contentView.addSubview(sortingNameLabel)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 5.0
    }
}
