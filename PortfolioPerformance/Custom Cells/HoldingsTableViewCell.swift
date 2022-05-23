//
//  HoldingsTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 11/04/2022.
//

import UIKit

class HoldingsTableViewCell: UITableViewCell {
    
    static let identifier = "HoldingsTableViewCell"
    static let prefferdHeight = 60
    
    struct ViewModel {
        let coinName: String
        let coinSymbol: String
        let CoinLogo: Data
        let currentHoldings: Double
        let averageBuyingPrice: Double
        let unrealizedGains: Double
        let realizedGains: Double
        let transferredGains: Double // gains from stacking etc
        let currentPrice: Double
        let holdingsValue: Double
        let holdingsValueCahnge: Double
        let holdingsValueChangePercentage: Double
    
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure (with viewModel: ViewModel) {
        
    }
}
