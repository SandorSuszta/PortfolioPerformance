//
//  Crypto.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 07/07/2022.
//

import Foundation
import UIKit

class CryptoCurrenciesTableViewCell: UITableViewCell {
    
    static let identifier = "MarketTableCell"
    static let prefferedHeight: CGFloat = 60
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.configureWithShadow()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .clouds

        logoContainerView.addSubview(logoImageView)
        addSubviews(nameLabel, symbolLabel, priceLabel, changeLabel, logoContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Add distance between the cells
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0))
        contentView.layer.cornerRadius = 25
        contentView.backgroundColor = .clouds
        backgroundColor = .clear
        
        let imageSize: CGFloat = contentView.height - 14
        logoContainerView.frame = CGRect(
            x: contentView.left + 10,
            y: 7,
            width: imageSize,
            height: imageSize
        )
        
        logoImageView.frame = CGRect(
            x: 2,
            y: 2,
            width: imageSize - 4 ,
            height: imageSize - 4
        )
        
        nameLabel.frame = CGRect(
            x: logoContainerView.right + 20,
            y: contentView.height/2 - nameLabel.height,
            width: (contentView.width - imageSize)/2,
            height: 20
        )
        
        symbolLabel.frame = CGRect(
            x: nameLabel.left,
            y: nameLabel.bottom,
            width: (contentView.width - imageSize)/2,
            height: 20)
        
        priceLabel.frame = CGRect(
            x: contentView.right - priceLabel.width - 20,
            y: nameLabel.top,
            width: symbolLabel.width - 10,
            height: 20)
        
        changeLabel.frame = CGRect(
            x: priceLabel.left,
            y: priceLabel.bottom,
            width: priceLabel.width,
            height: 20)
        
        contentView.backgroundColor = .clouds
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configureCell(with viewModel: CryptoCurrencyTableCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.currentPrice
        changeLabel.text = viewModel.priceChangePercentage24H
        changeLabel.textColor = viewModel.coinModel.priceChange24H ?? 0 >= 0 ? .nephritis : .pomergranate
        
        logoImageView.setImage(imageData: viewModel.imageData, imageUrl: viewModel.imageUrl)
    }
}

