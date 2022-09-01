//
//  DetailsViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 25/08/2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var headerViewModel: CryptoCurrencyViewModel
    
    private var isInWatchlist: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // Header View and Its Elements
    private var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .regular)
        return label
    }()
    
    private var priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private var priceChangePercentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private var coinLogoShadowView: UIImageView = {
        let view = UIImageView()
        view.configureWithShadow()
        view.backgroundColor = .white
        return view
    }()
    
    private var coinLogoView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    //Chart View
    private var chartView: UIView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = headerViewModel.name
        setupHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubviews(headerView)
        
        headerView.addSubviews(symbolLabel, priceLabel, priceChangeLabel, priceChangePercentageLabel, coinLogoShadowView)
        
        coinLogoShadowView.addSubview(coinLogoView)
        
        symbolLabel.sizeToFit()
        priceLabel.sizeToFit()
        priceChangeLabel.sizeToFit()
        priceChangePercentageLabel.sizeToFit()
        
        headerView.frame = CGRect(
            x: 0,
            y: 90,
            width: view.width,
            height: 170
        )
        
        symbolLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: symbolLabel.height
        )
        
        coinLogoShadowView.frame = CGRect(
            x: view.right - 120,
            y: symbolLabel.bottom + 20,
            width: 85,
            height: 85
        )
        
        coinLogoView.frame = CGRect(
            x: 10,
            y: 10,
            width: coinLogoShadowView.width - 20,
            height: coinLogoShadowView.height - 20
        )
        
        priceLabel.frame = CGRect(
            x: 35,
            y: coinLogoShadowView.top + (coinLogoShadowView.height - priceLabel.height - priceChangeLabel.height)/2,
            width: priceLabel.width,
            height: priceLabel.height
        )
        
        priceChangeLabel.frame = CGRect(
            x: priceLabel.left,
            y: priceLabel.bottom + 5,
            width: priceChangeLabel.width,
            height: priceChangeLabel.height
        )
        
        priceChangePercentageLabel.frame = CGRect(
            x: priceChangeLabel.right + 5,
            y: priceChangeLabel.top,
            width: priceChangePercentageLabel.width,
            height: priceChangePercentageLabel.height
        )
        
    }
    
    //MARK: - Methods
    
    private func setupHeaderView() {
        
        symbolLabel.text = headerViewModel.symbol
        priceLabel.text = headerViewModel.currentPrice
        priceChangeLabel.text = headerViewModel.priceChange24H
        priceChangePercentageLabel.text = "(" + headerViewModel.priceChangePercentage24H + ")"
        
        coinLogoView.setImage(
            imageData: headerViewModel.imageData,
            imageUrl: headerViewModel.imageUrl
        )
        
        if headerViewModel.isPriceChangeNegative  {
            priceChangeLabel.textColor = .pomergranate
            priceChangePercentageLabel.textColor = .pomergranate
        } else {
            priceChangeLabel.textColor = .nephritis
            priceChangePercentageLabel.textColor = .nephritis
        }
    }
    //MARK: - Init
    
    init(headerViewModel: CryptoCurrencyViewModel) {
        self.headerViewModel = headerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
