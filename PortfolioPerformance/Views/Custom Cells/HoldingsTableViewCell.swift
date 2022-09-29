////
////  HoldingsTableViewCell.swift
////  PortfolioPerformance
////
////  Created by Nataliia Shusta on 11/04/2022.
////
//
//import UIKit
//
//class HoldingsTableViewCell: UITableViewCell {
//    
//    static let identifier = "HoldingsTableViewCell"
//    static let prefferedHeight: CGFloat = 85
//    
//    struct ViewModel {
//        let coinName: String
//        let coinSymbol: String
//        //let CoinLogo: Data
//        let holdings: String
//        let averageBuyingPrice: String
//        let unrealizedGains: String
//        let realizedGains: String
//        let transferredGains: String // gains from stacking etc
//        let currentPrice: String
//        let holdingsValue: String
//        let holdingsValueCange: String
//        let holdingsValueChangePercentage: String
//        let holdingsPortfolioAllocation: String
//        let changeColor: UIColor
//    }
//    
//    private let logoContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGray6
//        view.configureWithShadow()
//        view.layer.cornerRadius = 25
//        return view
//    }()
//    
//    private let logoImageView: UIImageView = {
//        let image = UIImageView()
//        image.clipsToBounds = true
//        image.layer.cornerRadius = 25
//        image.contentMode = .scaleAspectFit
//        return image
//    }()
//    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        return label
//    }()
//    
//    private let symbolLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .secondaryLabel
//        label.font = .systemFont(ofSize: 14, weight: .regular)
//        return label
//    }()
//    
//    private let holdingsLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 12, weight: .regular)
//        return label
//    }()
//    
//    private let holdingsValueLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//        label.textAlignment = .right
//        return label
//    }()
//    
//    private let holdingsValueChangeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 14, weight: .regular)
//        return label
//    }()
//    
//    private let holdingsValueChangePercentageLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .secondaryLabel
//        label.font = .systemFont(ofSize: 14, weight: .regular)
//        return label
//    }()
//    
//    private let holdingsPortfolioAllocationLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .secondaryLabel
//        label.font = .systemFont(ofSize: 12, weight: .regular)
//        return label
//    }()
//    
//    private let allocationProgressView: CustomProgressView = {
//        let progressBar = CustomProgressView()
//        progressBar.customHeight = 7
//        progressBar.tintColor = .systemGray2
//        progressBar.layer.cornerRadius = 4
//        progressBar.clipsToBounds = true
//       
//        return progressBar
//    }()
//    
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubviews(
//            nameLabel,
//            symbolLabel,
//            logoContainerView,
//            holdingsValueLabel,
//            holdingsLabel,
//            allocationProgressView,
//            holdingsPortfolioAllocationLabel,
//            holdingsValueChangePercentageLabel,
//            holdingsValueChangeLabel
//        )
//        
//        logoContainerView.addSubview(logoImageView)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        nameLabel.sizeToFit()
//        symbolLabel.sizeToFit()
//        holdingsValueLabel.sizeToFit()
//        holdingsLabel.sizeToFit()
//        holdingsPortfolioAllocationLabel.sizeToFit()
//        holdingsValueChangePercentageLabel.sizeToFit()
//        holdingsValueChangeLabel.sizeToFit()
//        
//        
//        let imageSize: CGFloat = nameLabel.height + symbolLabel.height + holdingsLabel.height - 5
//        
//        logoContainerView.frame = CGRect(
//            x: contentView.left + 10,
//            y: contentView.height/2 - imageSize/2,
//            width: imageSize,
//            height: imageSize
//        )
//        
//        logoImageView.frame = CGRect(
//            x: 2,
//            y: 2,
//            width: imageSize - 4,
//            height: imageSize - 4
//        )
//        
//        nameLabel.frame = CGRect(
//            x: logoContainerView.right + 20,//(contentView.width - nameLabel.width)/2,
//            y: contentView.height/2 - (imageSize + 10)/2,
//            width: nameLabel.width,
//            height: nameLabel.height
//        )
//        
//        symbolLabel.frame = CGRect(
//            x: logoContainerView.right + 20,//(contentView.width - symbolLabel.width)/2,
//            y: nameLabel.bottom,
//            width: symbolLabel.width,
//            height: symbolLabel.height
//        )
//        
//        holdingsValueLabel.frame = CGRect(
//            x: contentView.right - holdingsValueLabel.width - 20,
//            y: nameLabel.top,
//            width: holdingsValueLabel.width,
//            height: holdingsValueLabel.height
//        )
//        
//        holdingsLabel.frame = CGRect(
//            x: symbolLabel.left,
//            y: symbolLabel.bottom + 5,
//            width: holdingsLabel.width,
//            height: holdingsLabel.height
//        )
//        
//        holdingsValueChangePercentageLabel.frame = CGRect(
//            x: contentView.right - holdingsValueChangePercentageLabel.width - 20,
//            y: holdingsValueLabel.bottom,
//            width: holdingsValueChangePercentageLabel.width,
//            height: holdingsValueChangePercentageLabel.height
//        )
//        
//        holdingsValueChangeLabel.frame = CGRect(
//            x: holdingsValueChangePercentageLabel.left - holdingsValueChangeLabel.width - 5,
//            y: holdingsValueLabel.bottom,
//            width: holdingsValueChangeLabel.width,
//            height: holdingsValueChangeLabel.height
//        )
//        
//        allocationProgressView.frame = CGRect(
//            x: contentView.right - allocationProgressView.width - holdingsPortfolioAllocationLabel.width - 25,
//            y: holdingsPortfolioAllocationLabel.top + holdingsPortfolioAllocationLabel.height/2 - allocationProgressView.height/2 ,
//            width: 50,
//            height: 20
//        )
//        
//        holdingsPortfolioAllocationLabel.frame = CGRect(
//            x: allocationProgressView.right + 5,
//            y: holdingsLabel.top,
//            width: holdingsPortfolioAllocationLabel.width,
//            height: holdingsPortfolioAllocationLabel.height
//        )
//    }
//    
//    
//    public func configure (with viewModel: HoldingsTableViewCellViewModel) {
//        nameLabel.text = viewModel.coinName
//        symbolLabel.text = viewModel.coinSymbol
//        holdingsLabel.text = viewModel.holdings
//        holdingsValueLabel.text = viewModel.holdingsValue
//        holdingsValueChangeLabel.text = viewModel.holdingsValueChange
//        holdingsValueChangeLabel.textColor = viewModel.isProfit ? .systemGreen : .systemRed
//        holdingsValueChangePercentageLabel.text = viewModel.holdingsValueChangePercentage
//        holdingsValueChangePercentageLabel.textColor = viewModel.isProfit ? .nephritis : .pomergranate
//        holdingsPortfolioAllocationLabel.text = viewModel.holdingsPortfolioAllocation
//        allocationProgressView.progress = viewModel.holdingPortfolioAllocation
//        logoImageView.setImage(imageData: viewModel.imageData, imageUrl: viewModel.imageUrl)
//    }
//}
