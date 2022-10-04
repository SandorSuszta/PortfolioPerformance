//
//  ResultsTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 10/05/2022.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    static let identifier = "ResultsTableViewCell"
    static let preferedHeight: CGFloat = 60
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        return view
    }()
    
    let logoView: UIImageView = {
        let logoView = UIImageView()
        return logoView
    }()
    
    
    public func configure (with searchResult: SearchResult) {
        
        symbolLabel.text = searchResult.symbol
        nameLabel.text = searchResult.name
        logoView.setImage(imageUrl: searchResult.large)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground

        logoContainerView.addSubview(logoView)
        contentView.addSubviews(symbolLabel, nameLabel, logoContainerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 20
        
        logoContainerView.frame = CGRect(
            x: contentView.left + 10,
            y: 10,
            width: imageSize,
            height: imageSize
        )
        
        logoView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize - 10,
            height: imageSize - 10
        )
        
        symbolLabel.sizeToFit()
        symbolLabel.frame = CGRect(
            x: logoContainerView.right + 10,
            y: 0,
            width: symbolLabel.width,
            height: contentView.height
        )
        
        nameLabel.frame = CGRect(
            x: symbolLabel.right + 10,
            y: 0,
            width: contentView.width - logoView.width - symbolLabel.width,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        logoView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

