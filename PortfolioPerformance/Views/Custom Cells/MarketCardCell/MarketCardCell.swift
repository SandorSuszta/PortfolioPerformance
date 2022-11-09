//
//  MarketCardsCollectionViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/06/2022.
//

import UIKit

class MarketCardCell: UICollectionViewCell {
    
    static let identifier = "MarketCardsCollectionViewCell"
    static let preferredHeight: CGFloat = 150
    static let preferredWidth: CGFloat = 120
    
    private var circleRadius: CGFloat {
        contentView.width / 1.35
    }
    
    var progressBar = CircularProgressBar(frame: .zero, type: .round, progress: 0, color: UIColor.pomergranate.cgColor)
    
    let headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 2
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let mainTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let secondaryTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubviews(
            headerTitle,
            mainTitle,
            secondaryTitle,
            progressBar
        )
        setupConstraints()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let circleRadius = contentView.width / 1.35
//
//        headerTitle.frame = CGRect(
//            x: 10,
//            y: 3,
//            width: contentView.width - 20,
//            height: 40
//        )
//        headerTitle.backgroundColor = .pomergranate
//
//        progressBar.frame = CGRect(
//            x: (contentView.width - circleRadius) / 2,
//            y: headerTitle.height + (contentView.height - headerTitle.height - circleRadius) / 2,
//            width: circleRadius,
//            height: circleRadius
//        )
//
//        //Gradient Type semicircle for GreedAndFear Index presentation
//        if progressBar.type == .gradient {
//            secondaryTitle.sizeToFit()
//            mainTitle.sizeToFit()
//
//            mainTitle.font = .systemFont(ofSize: 18, weight: .semibold)
//            secondaryTitle.font = .systemFont(ofSize: 16, weight: .semibold)
//
//            mainTitle.frame = CGRect(
//                x: contentView.width/2 - mainTitle.width/2,
//                y: progressBar.top + progressBar.height/2 - mainTitle.height/2,
//                width: mainTitle.width,
//                height: mainTitle.height
//            )
//
//            secondaryTitle.frame = CGRect(
//                x: contentView.width/2 - contentView.width / 2.4,
//                y: contentView.bottom - contentView.width / 5,
//                width: contentView.width / 1.2,
//                height: secondaryTitle.font.pointSize
//            )
//
//        } else {
//
//            mainTitle.frame = CGRect(
//                x: (contentView.width - circleRadius) / 2 + 13,
//                y: progressBar.top + progressBar.height / 2 - mainTitle.font.pointSize / 2,
//                width: circleRadius - 26,
//                height: mainTitle.font.pointSize
//            )
//
//            secondaryTitle.frame = CGRect(
//                x: contentView.width/2 - mainTitle.width / 3.2,
//                y: mainTitle.bottom,
//                width: mainTitle.width / 1.6,
//                height: secondaryTitle.font.pointSize
//            )
//        }
//    }
    
    private func setupConstraints() {
         
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            headerTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            headerTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -10),
            headerTitle.heightAnchor.constraint(equalToConstant: 40),
            
            progressBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            progressBar.widthAnchor.constraint(equalToConstant: contentView.width - 30),
            progressBar.heightAnchor.constraint(equalToConstant: contentView.width - 30),
            
            mainTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            mainTitle.widthAnchor.constraint(equalToConstant: contentView.width - 55),
            
            secondaryTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor),
            secondaryTitle.centerXAnchor.constraint(equalTo: mainTitle.centerXAnchor),
        ])
        
    }
    
    private func updateLayoutForGreedAndFearType() {
        mainTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        secondaryTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        
        NSLayoutConstraint.activate([
            secondaryTitle.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.height / 5)),
            secondaryTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            secondaryTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            secondaryTitle.heightAnchor.constraint(equalToConstant: contentView.height / 5)
        ])
    }
    
    public func configureCard(with viewModel: MarketCardCellViewModel) {
        progressBar.type = viewModel.progressBarType
        progressBar.progress = viewModel.progressValue
        progressBar.color = viewModel.secondaryMetricTextColor.cgColor
        
        headerTitle.text = viewModel.metricName
        mainTitle.text = viewModel.mainMetricValue
        secondaryTitle.text = viewModel.secondaryMetricValue
        
        switch progressBar.type {
            
        case .round:
            secondaryTitle.textColor = viewModel.secondaryMetricTextColor
            secondaryTitle.text = viewModel.secondaryMetricValue
            
        case .gradient:
            secondaryTitle.text = viewModel.secondaryMetricValue
            secondaryTitle.textColor = viewModel.secondaryMetricTextColor
            updateLayoutForGreedAndFearType()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


