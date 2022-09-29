//
//  CurrentPortfolioViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 19/05/2022.
//

import UIKit

class CurrentPortfolioView: UIView {
    
    let portfolioValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .label
        label.text = "$4590.65"
        return label
    }()
    
    let portfolioChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemRed
        label.text = "-3200.35"
        return label
    }()
    
    let portfolioChangeInPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemRed
        label.text = "(-75.35%)"
        return label
    }()
    
    //MARK: - Chart
    let chartContainerView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(
            portfolioValueLabel,
            portfolioChangeLabel,
            portfolioChangeInPercentageLabel,
            chartContainerView
        )
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
   
        portfolioValueLabel.sizeToFit()
        portfolioChangeLabel.sizeToFit()
        portfolioChangeInPercentageLabel.sizeToFit()
        
        portfolioValueLabel.frame = CGRect(
            x: (width - portfolioValueLabel.width)/2,
            y: safeAreaInsets.bottom + 10,
            width: portfolioValueLabel.width,
            height: portfolioValueLabel.height
        )
        
        portfolioChangeLabel.frame = CGRect(
            x: (width - portfolioChangeLabel.width - portfolioChangeInPercentageLabel.width)/2,
            y: portfolioValueLabel.bottom + 10,
            width: portfolioChangeLabel.width,
            height: portfolioChangeLabel.height
        )
        
        portfolioChangeInPercentageLabel.frame = CGRect(
            x: portfolioChangeLabel.right + 5,
            y: portfolioValueLabel.bottom + 10,
            width: portfolioChangeInPercentageLabel.width,
            height: portfolioChangeInPercentageLabel.height
        )
        
        
        //MARK: - Chart
        chartContainerView.frame = CGRect(
            x: 20,
            y: portfolioChangeLabel.bottom + 20,
            width: width - 40,
            height: 200
        )
    }
}
