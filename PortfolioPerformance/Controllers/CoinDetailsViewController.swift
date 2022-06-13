//
//  CoinDetailsViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 10/02/2022.
//

import UIKit
import Charts

class CoinDetailsViewController: UIViewController  {
    
    public var coinModel: CoinModel? = nil
    
    private var chartTimeInterval = 1
    private var rangeName = ""
    private var priceChange = 0.0
    
    @IBOutlet weak var coinLogo: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeInPercentageLabel: UILabel!
    @IBOutlet weak var coinLogoView: UIView!
    @IBOutlet weak var isFavouriteButton: UIBarButtonItem!
    @IBOutlet weak var chartShadowView: UIView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var coinDetailsView: UIView!
    
    //MARK: CoinDetails
    
    @IBOutlet weak var coinRankLabel: UILabel!
    
    @IBOutlet weak var coinMarketCapLabel: UILabel!
    
    @IBOutlet weak var coinVolumeLabel: UILabel!
    
    @IBOutlet weak var rangeLowLabel: UILabel!
    @IBOutlet weak var rangeNameLabel: UILabel!
    @IBOutlet weak var percentSinceHighLabel: UILabel!
    @IBOutlet weak var percentSinceLowLabel: UILabel!
    @IBOutlet weak var rangeHigh: UILabel!
    
    @IBOutlet weak var allTimeHighDateLabel: UILabel!
    @IBOutlet weak var allTimeHighLabel: UILabel!
    @IBOutlet weak var percentSinceAllTimeHighLabel: UILabel!
    
    @IBOutlet weak var rangeProgressView: UIProgressView!
    @IBOutlet weak var allTimeHighProgressView: UIProgressView!
    
    @IBAction func dateIntervalChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartTimeInterval = 1
            rangeName = "1D Range"
        case 1:
            chartTimeInterval = 7
            rangeName = "1W Range"
        case 2:
            chartTimeInterval = 30
            rangeName = "1M Range"
        case 3:
            chartTimeInterval = 180
            rangeName = "6M Range"
        case 4:
            chartTimeInterval = 360
            rangeName = "1Y Range"
        case 5:
            chartTimeInterval = 2000
            rangeName = "Max Range"
        default:
            fatalError()
        }
        fetchData(forCoinID: coinModel?.id ?? "", forPeriodOfDays: chartTimeInterval)
        rangeNameLabel.text = rangeName
    }
    
    @IBAction func isFavouriteButtonClicked(_ sender: Any) {
        
        guard let symbol = coinModel?.symbol else { return }
        
        if WatchlistViewController.watchlistCoins.contains(symbol)
        {
            WatchlistViewController.watchlistCoins.removeAll { $0 == symbol }
            isFavouriteButton.image = UIImage(named: "favourite")
        } else {
            WatchlistViewController.watchlistCoins.append(symbol)
            isFavouriteButton.image = UIImage(named: "favourite.fill")
        }
    }
    
    var chartPriceArray: [[Double]] = [] {
        didSet{
            DispatchQueue.main.async {
                if self.priceChange >= 0 {
                    self.createGraph(color: .nephritis)
                } else {
                    self.createGraph(color: .pomergranate)
                }
                
                self.updateCoinDetails()
            }
        }
    }
    
    private var isFavourite: Bool {
        WatchlistViewController.watchlistCoins.contains(coinModel?.symbol ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isFavouriteButton.image = isFavourite ? UIImage(named: "favourite.fill") : UIImage(named: "favourite")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressView(progressView: rangeProgressView)
        setupProgressView(progressView: allTimeHighProgressView)
        
        //Remove NavBar Border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        
        fetchData(forCoinID: coinModel?.id ?? "", forPeriodOfDays: 1)
        
        chartShadowView.configureWithShadow()
        coinDetailsView.configureWithShadow()
        
        //view
        coinLogoView.layer.cornerRadius = 15
        
        coinLogoView.layer.shadowColor = UIColor.lightGray.cgColor
        coinLogoView.layer.shadowOffset = .zero
        coinLogoView.layer.shadowOpacity = 0.5
        coinLogoView.layer.shadowRadius = 5.0
        coinLogo.layer.cornerRadius = 15
        coinLogo.layer.masksToBounds = true
        
        title = coinModel?.name
        
        symbolLabel.text = coinModel?.symbol.uppercased()
        
        priceLabel.text = "$\(coinModel?.currentPrice ?? 0)"
        
        if coinModel?.priceChange24H ?? 0 < 0 {
            priceChangeLabel.text = String(format:"%.3f", coinModel?.priceChange24H ?? 0)
            priceChangeLabel.textColor = UIColor.pomergranate
            priceChangeInPercentageLabel.text = String(format:"(%.2f", coinModel?.priceChangePercentage24H ?? 0)+"%)"
            priceChangeInPercentageLabel.textColor = UIColor.pomergranate
        } else {
            priceChangeLabel.text = String(format:"+%.3f", coinModel?.priceChange24H ?? 0)
            priceChangeLabel.textColor = UIColor.nephritis
            priceChangeInPercentageLabel.text = String(format: "(+%.2f", coinModel?.priceChangePercentage24H ?? 0)+"%)"
            priceChangeInPercentageLabel.textColor = UIColor.nephritis
        }
        
        if let imageData = coinModel?.imageData {
            coinLogo.image = UIImage(data: imageData)
        } else {
            if let url = URL(string: coinModel?.image ?? "") {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
//                            coin.imageData = data
                        DispatchQueue.main.async {
                            self.coinLogo.image = UIImage(data: data)
                        }
                    } else {
                        print("Error getting image")
                    }
                }
                task.resume()
            }
        }
    }
   
    //MARK: - Setup Chart
    
    func fetchData(forCoinID coinID: String, forPeriodOfDays days: Int) {
        
        APICaller.shared.getHistoricalPrices(for: coinID, intervalInDays: days) { result in
            switch result {
            case .success(let entries):
                
                self.chartPriceArray = entries.prices
                
                self.priceChange = entries.prices[entries.prices.count - 1][1]
                - entries.prices[0][1]
                
                let priceChangeInPercentage = (entries.prices[entries.prices.count - 1][1]/entries.prices[0][1]) * 100 - 100
               
                // Update priceChange labels with price and color based on plus or minus
                DispatchQueue.main.async {
                    if self.priceChange >= 0 {
                        self.priceChangeLabel.text = "+" + self.priceChange.string2f()
                        self.priceChangeLabel.textColor = .nephritis
                        self.priceChangeInPercentageLabel.textColor = .nephritis
                    } else {
                        self.priceChangeLabel.text = self.priceChange.string2f()
                        self.priceChangeLabel.textColor = .pomergranate
                        self.priceChangeInPercentageLabel.textColor = .pomergranate
                        
                    }
                    self.priceChangeInPercentageLabel.text = "(" + priceChangeInPercentage.string2f() + "%)"
                }
                
            case .failure(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func createGraph(color: UIColor) {
        let lineChartView = LineChartView(frame: CGRect(x: 0, y: 0,
                                                        width: self.chartView.frame.width,
                                                        height: self.chartView.frame.height))
        self.chartView.addSubview(lineChartView)
        
        var graphEntries: [ChartDataEntry] = []
        
        for price in self.chartPriceArray {
                let entry = ChartDataEntry(x: price[0], y: price[1])
                graphEntries.append(entry)
        }
        
        let dataSet = LineChartDataSet(entries: graphEntries)
        
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .horizontalBezier
        dataSet.lineWidth = 1
        dataSet.cubicIntensity = 0.01
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        dataSet.highlightLineWidth = 3
        dataSet.setColor(color)
    
        
        let gradientColors = [color.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0) // Set gradient
        dataSet.drawFilledEnabled = true // Draw the Gradient
    

        lineChartView.data = LineChartData(dataSet: dataSet)
        lineChartView.data?.setDrawValues(false)

        lineChartView.backgroundColor = .clouds
        lineChartView.leftAxis.enabled = false // Disable right axis
        lineChartView.xAxis.labelPosition = .bottom // Labels on the bottom
        lineChartView.xAxis.drawGridLinesEnabled = false // Disable vertical grids
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.gridColor = .darkClouds
        lineChartView.legend.enabled = false // Disable legend
        lineChartView.xAxis.setLabelCount(4, force: true) // How many labels on axis
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
       
        lineChartView.animate(xAxisDuration: 1)
        
        // Disable zooming
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
        lineChartView.xAxis.valueFormatter = self // Declare self as the Formatter, conform to AxisValueFormatter
    }
    
    
    //MARK: Setup Range Bars
    
    func setupProgressView(progressView: UIProgressView) {
        progressView.trackTintColor
        = .pinkGlamour
        progressView.progressTintColor = .emerald
        progressView.layer.cornerRadius = 6
        progressView.clipsToBounds = true
    }
    
    //MARK: Update Coin Details
    
    func updateCoinDetails () {
        
        let sortedPriceArray = chartPriceArray.sorted {
            $0[1] < $1[1]
        }
        
        
        
        guard let coinModel = coinModel,
              let priceLow = sortedPriceArray.first?[1],
              let priceHigh = sortedPriceArray.last?[1],
              let ath = coinModel.ath,
              let athDate = coinModel.athDate
                
        else { fatalError() }
        
        coinRankLabel.text = "#\(Int(coinModel.marketCapRank ?? 0))"
        coinMarketCapLabel.text = "$\(coinModel.marketCap ?? 0)"
        coinVolumeLabel.text = "\(coinModel.totalVolume)"
        
        rangeLowLabel.text = priceLow.string2f()
        rangeHigh.text = priceHigh.string2f()
        
        let rangeProgress = Float((coinModel.currentPrice - priceLow) / (priceHigh - priceLow))
        rangeProgressView.setProgress(rangeProgress, animated: true)
        
        let percentSinceLow = 100 - (coinModel.currentPrice / priceLow * 100)
        let percentSinceHigh = 100 - (coinModel.currentPrice / priceHigh * 100)
        percentSinceLowLabel.text = "+" + percentSinceLow.string2f() + "%"
        percentSinceHighLabel.text = "-" + percentSinceHigh.string2f() + "%"
        
        let percentSinceAllTimeHigh = coinModel.currentPrice / ath * 100 - 100
        
        //Convert ISO8601 Date from API
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        let convertedDate = isoFormatter.date(from: athDate)
        
        allTimeHighLabel.text = ath.string2f()
        percentSinceAllTimeHighLabel.text = percentSinceAllTimeHigh.string2f() + "%"
        allTimeHighDateLabel.text = convertedDate?.formatedString()
        
        allTimeHighProgressView.progress = Float(coinModel.currentPrice / ath)
    }
}

extension CoinDetailsViewController: AxisValueFormatter, ChartViewDelegate {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
       return Date(timeIntervalSince1970: value/1000).stringForGraph(forDays: chartTimeInterval)
    }
}
