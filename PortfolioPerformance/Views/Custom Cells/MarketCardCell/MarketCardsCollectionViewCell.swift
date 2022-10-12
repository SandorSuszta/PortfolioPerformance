//
//  MarketCardsCollectionViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/06/2022.
//

import UIKit

class MarketCardsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MarketCardsCollectionViewCell"
    static let preferredHeight: CGFloat = 150
    static let preferredWidth: CGFloat = 120
    
    var progressBar = CircularProgressBar(frame: .zero, type: .round, progress: 0, color: UIColor.pomergranate.cgColor)
    
    let headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 2
        title.textAlignment = .center
        return title
    }()
    
    let mainTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        return title
    }()
    
    let secondaryTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        title.textColor = .pomergranate
        return title
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubviews(
            headerTitle,
            mainTitle,
            secondaryTitle,
            progressBar
        )
        backgroundColor = .clouds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleRadius = contentView.width / 1.35
        
        headerTitle.frame = CGRect(
            x: 10,
            y: 3,
            width: contentView.width - 20,
            height: 40
        )
        
        progressBar.frame = CGRect(
            x: (contentView.width - circleRadius) / 2,
            y: headerTitle.height + (contentView.height - headerTitle.height - circleRadius) / 2,
            width: circleRadius,
            height: circleRadius
        )

        //Gradient Type semicircle for GreedAndFear Index presentation
        if progressBar.type == .gradient {
            secondaryTitle.sizeToFit()
            mainTitle.sizeToFit()
            
            mainTitle.font = .systemFont(ofSize: 18, weight: .semibold)
            secondaryTitle.font = .systemFont(ofSize: 16, weight: .semibold)
            
            mainTitle.frame = CGRect(
                x: contentView.width/2 - mainTitle.width/2,
                y: progressBar.top + progressBar.height/2 - mainTitle.height/2,
                width: mainTitle.width,
                height: mainTitle.height
            )
            
            secondaryTitle.frame = CGRect(
                x: contentView.width/2 - contentView.width / 2.4,
                y: contentView.bottom - contentView.width / 5,
                width: contentView.width / 1.2,
                height: secondaryTitle.font.pointSize
            )
            
        } else {
    
            mainTitle.frame = CGRect(
                x: (contentView.width - circleRadius) / 2 + 13,
                y: progressBar.top + progressBar.height / 2 - mainTitle.font.pointSize / 2,
                width: circleRadius - 26,
                height: mainTitle.font.pointSize
            )
  
            secondaryTitle.frame = CGRect(
                x: contentView.width/2 - mainTitle.width / 3.2,
                y: mainTitle.bottom,
                width: mainTitle.width / 1.6,
                height: secondaryTitle.font.pointSize
            )
        }
    }
    
    public func configureCard(with viewModel: MarketCardsCollectionViewCellViewModel) {
        progressBar.type = viewModel.progressCircleType
        progressBar.progress = viewModel.progressValue
        progressBar.color = viewModel.changeColour.cgColor
        
        headerTitle.text = viewModel.headerTitle
        mainTitle.text = viewModel.mainTitle
        secondaryTitle.text = viewModel.secondaryTitle
        
        switch progressBar.type {
            
        case .round:
            secondaryTitle.textColor = viewModel.changeColour
            secondaryTitle.text = viewModel.secondaryTitle
            
        case .gradient:
            secondaryTitle.text = viewModel.secondaryTitle
            
            //Change label color based on the GreedAbdFear index value
            switch Int(viewModel.mainTitle) ?? 0 {
            case 0...20:
                secondaryTitle.textColor = .pomergranate
            case 21...40:
                secondaryTitle.textColor = .alizarin
            case 41...54:
                secondaryTitle.textColor = .carrot
            case 55...74:
                secondaryTitle.textColor = .emerald
            case 75...100:
                secondaryTitle.textColor = .nephritis
            default:
                fatalError()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


