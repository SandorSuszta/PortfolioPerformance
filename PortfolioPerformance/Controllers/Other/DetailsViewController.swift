//
//  DetailsViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 25/08/2022.
//

import UIKit

class DetailsViewController: UIViewController {
//    @IBOutlet weak var symbolLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var priceChangeLabel: UILabel!
//    @IBOutlet weak var priceChangeInPercentageLabel: UILabel!
//    @IBOutlet weak var coinLogoView: UIView!
//    @IBOutlet weak var isFavouriteButton: UIBarButtonItem!
//    @IBOutlet weak var chartShadowView: UIView!
//    @IBOutlet weak var chartView: UIView!
//    @IBOutlet weak var coinDetailsView: UIView!
    var coinModel: CoinModel?
    
    private var symbolLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var priceChangeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var priceChangePercentageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var coinLogoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var chartView: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
