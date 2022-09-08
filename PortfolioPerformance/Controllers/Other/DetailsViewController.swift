//
//  DetailsViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 25/08/2022.
//

import UIKit
import Charts

class DetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: CoinDetailsViewModel
    
    private var currentChartTimeInterval = 1
    
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
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var priceChangePercentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
//    private var intervalDescriptionLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14, weight: .semibold)
//        label.textColor = .systemGray
//        label.text = "Last day"
//        return label
//    }()
    
    private var coinLogoShadowView: UIImageView = {
        let view = UIImageView()
        view.configureWithShadow()
        view.backgroundColor = .white
        return view
    }()
    
    private var coinLogoView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    //Chart View
    private var chartView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        return view
    }()
    
    private var lineChartView = LineChartView()
    
    private var timeIntervalSelection: UISegmentedControl = {
        let items = ["1D", "1W", "1M", "6M", "1Y", "MAX"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.cornerRadius = 5
        segmentControl.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        
        return segmentControl
    }()

    private var rangeProgressBar: RangeProgressBar = {
        let bar = RangeProgressBar()
        bar.configureWithShadow()
        bar.titleLabel.text = "Day range"
        bar.progressBar.progress = 0.5
        bar.titleLabel.sizeToFit()
        return bar
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = viewModel.name
        setup()
        viewModel.getChartDataEntries(coinID: viewModel.coinModel.id, intervalInDays: currentChartTimeInterval)
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubviews(symbolLabel, priceLabel, priceChangeLabel, priceChangePercentageLabel, coinLogoShadowView, chartView, timeIntervalSelection, rangeProgressBar)
        //intervalDescriptionLabel
        
        coinLogoShadowView.addSubview(coinLogoView)
        chartView.addSubviews(lineChartView)
        
        symbolLabel.sizeToFit()
        priceLabel.sizeToFit()
        priceChangeLabel.sizeToFit()
        priceChangePercentageLabel.sizeToFit()
//        intervalDescriptionLabel.sizeToFit()
        
        symbolLabel.frame = CGRect(
            x: 0,
            y: 90,
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
            y: coinLogoShadowView.top + (coinLogoShadowView.height - priceLabel.height - priceChangePercentageLabel.height)/2,
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
        
//        intervalDescriptionLabel.frame = CGRect(
//            x: priceChangePercentageLabel.right + 5,
//            y: priceChangeLabel.top,
//            width: intervalDescriptionLabel.width,
//            height: intervalDescriptionLabel.height
//        )
        
        //Graph
        chartView.frame = CGRect(
            x: 20,
            y: coinLogoShadowView.bottom + 20,
            width: view.width - 40,
            height: 200
        )
        
        lineChartView.frame = CGRect(
            x: 5,
            y: 5,
            width: self.chartView.frame.width - 10,
            height: self.chartView.frame.height - 15
        )
     
        timeIntervalSelection.frame = CGRect(
            x: 20,
            y: chartView.bottom + 15,
            width: chartView.width,
            height: 25
        )
        
        //Progress bars
        rangeProgressBar.frame = CGRect(
            x: 20,
            y: timeIntervalSelection.bottom + 15,
            width: chartView.width,
            height: 60
        )
    }
    
    //MARK: - Bind View Model

    private func bindViewModel() {
        
        viewModel.chartDataEntries.bind { [weak self] _ in
            guard let entries = self?.viewModel.chartDataEntries.value else { return }
            
            DispatchQueue.main.async {
                self?.createGraph(entries: entries, color: .emerald)
            }
        }
        
        viewModel.rangeData.bind { [weak self] _ in
            
            guard let data = self?.viewModel.rangeData.value else { return }
    
            DispatchQueue.main.async {
                
                self?.priceChangeLabel.text = data.rangePriceChange
                self?.priceChangeLabel.sizeToFit()
                self?.priceChangePercentageLabel.text = "(" + data.rangePriceChangePercentage + ")"
                self?.priceChangeLabel.sizeToFit()
                
                if data.isChangeNegative  {
                    self?.priceChangeLabel.textColor = .pomergranate
                    self?.priceChangePercentageLabel.textColor = .pomergranate
                } else {
                    self?.priceChangeLabel.textColor = .nephritis
                    self?.priceChangePercentageLabel.textColor = .nephritis
                }

                self?.setupProgressBars(
                    rangeLow: data.rangeLow,
                    rangeHigh: data.rangeHigh,
                    percentageFromLow: data.percentFromLow,
                    percentageFromHigh: data.percentFromHigh,
                    athPrice: self?.viewModel.athPrice ?? "",
                    athDate: self?.viewModel.athDate ?? "",
                    rangeProgress: data.rangeProgress,
                    athProgress: 0.0
                )
            }
        }
    }
    
    //MARK: - Init
    
    init(coinModel: CoinModel) {
        self.viewModel = CoinDetailsViewModel(coinModel: coinModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    //MARK: - Private methods
    
    private func setup() {
        
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.currentPrice
        priceChangeLabel.text = viewModel.priceChange24H
        priceChangePercentageLabel.text = "(" + viewModel.priceChangePercentage24H + ")"
        
        coinLogoView.setImage(
            imageData: viewModel.imageData,
            imageUrl: viewModel.imageUrl
        )
        
        if viewModel.isPriceChangeNegative  {
            priceChangeLabel.textColor = .pomergranate
            priceChangePercentageLabel.textColor = .pomergranate
        } else {
            priceChangeLabel.textColor = .nephritis
            priceChangePercentageLabel.textColor = .nephritis
        }
    }
    
    private func setupProgressBars(rangeLow: String, rangeHigh: String, percentageFromLow: String, percentageFromHigh: String, athPrice: String, athDate: String, rangeProgress: Float, athProgress: Double) {
        
        rangeProgressBar.rightTopLabel.text = rangeHigh
        rangeProgressBar.rightTopLabel.sizeToFit()
        
        rangeProgressBar.rightBottomLabel.text = percentageFromHigh
        rangeProgressBar.rightBottomLabel.sizeToFit()
        
        rangeProgressBar.leftTopLabel.text = rangeLow
        rangeProgressBar.leftTopLabel.sizeToFit()
        
        rangeProgressBar.leftBottomLabel.text = percentageFromLow
        rangeProgressBar.leftBottomLabel.sizeToFit()
        
        rangeProgressBar.progressBar.setProgress(rangeProgress, animated: true)
        
    }
    
    private func createGraph(entries: [ChartDataEntry], color: UIColor = .emerald) {
        
        let dataSet = LineChartDataSet(entries: entries)
        
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .horizontalBezier
        dataSet.lineWidth = 2
        dataSet.cubicIntensity = 2
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        dataSet.highlightLineWidth = 1
        dataSet.setColor(color)
    
        let gradientColors = [color.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0) // Set gradient
        dataSet.drawFilledEnabled = true // Draw the Gradient

        lineChartView.data = LineChartData(dataSet: dataSet)
        lineChartView.data?.setDrawValues(false)

        lineChartView.backgroundColor = .white
        lineChartView.leftAxis.enabled = false // Disable right axis
        lineChartView.xAxis.labelPosition = .bottom // Labels on the bottom
        lineChartView.xAxis.drawGridLinesEnabled = false // Disable vertical grids
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.gridColor = .darkClouds
        lineChartView.legend.enabled = false // Disable legend
        lineChartView.xAxis.setLabelCount(4, force: true) // How many labels on axis
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
       
        //lineChartView.animate(xAxisDuration: 1)
        
        // Disable zooming
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
        // Declare self as the Formatter, conform to AxisValueFormatter
        lineChartView.xAxis.valueFormatter = self
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) -> Void {
        
//        var intervalName = ""
        var rangeName = ""
        switch sender.selectedSegmentIndex {
        case 0:
            currentChartTimeInterval = 1
//            intervalName = "Last day"
            rangeName = "Day range"
        case 1:
            currentChartTimeInterval = 7
//            intervalName = "Last week"
            rangeName = "Week Range"
        case 2:
            currentChartTimeInterval = 30
//            intervalName = "Last month"
            rangeName = "Month range"
        case 3:
            currentChartTimeInterval = 180
//            intervalName = "Last 6 months"
            rangeName = "Six month range"
        case 4:
            currentChartTimeInterval = 360
//            intervalName = "Year Range"
            rangeName = "Year range"
        case 5:
            currentChartTimeInterval = 2000
//            intervalName = "All time"
            rangeName = "All time range"
        default:
            fatalError("Invalid segment selection")
        }
        
//        intervalDescriptionLabel.text = intervalName
//        intervalDescriptionLabel.sizeToFit()
        rangeProgressBar.titleLabel.text = rangeName
        rangeProgressBar.titleLabel.sizeToFit()
        
        viewModel.getChartDataEntries(coinID: viewModel.coinModel.id, intervalInDays: currentChartTimeInterval)
    }
}

extension DetailsViewController: AxisValueFormatter, ChartViewDelegate {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        let date = Date(timeIntervalSince1970: value/1000)
        
        return .stringForGraphAxis(from: date, daysInterval: currentChartTimeInterval)
    }
}
