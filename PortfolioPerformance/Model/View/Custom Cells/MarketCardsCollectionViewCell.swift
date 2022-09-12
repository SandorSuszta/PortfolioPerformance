//
//  MarketCardsCollectionViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/06/2022.
//

import UIKit

class MarketCardsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MarketCardsCollectionViewCell"
    //static let preferredHeight: CGFloat =  100
    
    var progressBar = CircularProgressBar(frame: .zero, type: .round, progress: 0, color: UIColor.pomergranate.cgColor)
    
    let headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 12, weight: .semibold)
        title.textAlignment = .center
        title.numberOfLines = 2
        return title
    }()
    
    let mainTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        return title
    }()
    
    let secondaryTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 10, weight: .semibold)
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
        mainTitle.sizeToFit()
        secondaryTitle.sizeToFit()
        
        headerTitle.frame = CGRect(
            x: 10,
            y: 10,
            width: contentView.width - 20,
            height: 40
        )
        
        progressBar.frame = CGRect(
            x: 20,
            y: 55,
            width: contentView.width - 40,
            height: contentView.width - 40
        )
        
        mainTitle.frame = CGRect(
            x: contentView.width/2 - mainTitle.width/2,
            y: progressBar.top + progressBar.height/2 - mainTitle.height/2,
            width: mainTitle.width,
            height: mainTitle.height
        )
        
        secondaryTitle.frame = CGRect(
            x: contentView.width/2 - secondaryTitle.width/2,
            y: mainTitle.bottom,
            width: secondaryTitle.width,
            height: secondaryTitle.height
        )
        
        //Gradient Type semicircle for GreedAndFear Index presentation
        if progressBar.type == .gradient {
            mainTitle.font = .systemFont(ofSize: 18, weight: .semibold)
            secondaryTitle.font = .systemFont(ofSize: 14, weight: .semibold)
            
            mainTitle.sizeToFit()
            secondaryTitle.sizeToFit()
            
            mainTitle.frame = CGRect(
                x: contentView.width/2 - mainTitle.width/2,
                y: progressBar.top + progressBar.height/2 - mainTitle.height/2,
                width: mainTitle.width,
                height: mainTitle.height
            )
            
            secondaryTitle.frame = CGRect(
                x: contentView.width/2 - secondaryTitle.width/2,
                y: contentView.bottom - 26,
                width: secondaryTitle.width,
                height: secondaryTitle.height
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


