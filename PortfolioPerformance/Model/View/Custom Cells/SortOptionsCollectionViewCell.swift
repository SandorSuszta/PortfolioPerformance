//
//  SortOptionsCollectionViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 07/07/2022.
//

import Foundation
import UIKit

class SortOptionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SortOptionsCollectionViewCell"
    
    public var sortingNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    //Configure selected cell
    override var isSelected: Bool {
        didSet {
            sortingNameLabel.textColor = isSelected ? .black : .darkGray
            contentView.backgroundColor = isSelected ? .clouds : .clear
            sortingNameLabel.layer.shadowRadius = isSelected ? 5.0 : 0.0
        }
    }
    override init(frame: CGRect) {
        super .init(frame: frame)
        sortingNameLabel.frame = contentView.bounds
        contentView.addSubview(sortingNameLabel)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 5.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
