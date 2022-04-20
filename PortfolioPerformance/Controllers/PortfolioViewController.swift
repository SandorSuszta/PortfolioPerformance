//
//  PortfolioViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 11/04/2022.
//

import UIKit
import Charts

class PortfolioViewController: UIViewController {
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    
    @IBOutlet weak var timeIntervalSegmentedControl: UISegmentedControl!
    
    @IBAction func timeIntervalChanged(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
    case 0:
        graphTimeInterval = 1
        fetchData(forPeriodOfDays: 1)
    case 1:
        graphTimeInterval = 7
        fetchData(forPeriodOfDays: 7)
    case 2:
        graphTimeInterval = 30
        fetchData(forPeriodOfDays: 30)
    case 3:
        graphTimeInterval = 180
        fetchData(forPeriodOfDays: 180)
    case 4:
        graphTimeInterval = 360
        fetchData(forPeriodOfDays: 360)
    case 5:
        graphTimeInterval = 2000
        fetchData(forPeriodOfDays: 2000)
    default:
        fatalError()
    }
}
    
    private var graphTimeInterval: Int = 1
    
    var priceArray: [[Double]] = [] {
        didSet{
            DispatchQueue.main.async {
                self.createGraph()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.configureWithShadow()
        fetchData(forPeriodOfDays: 1)
        
        //Remove NavBar Border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func fetchData(forPeriodOfDays days: Int) {
        
        APICaller.shared.getHistoricalPrices(for: "bitcoin", intervalInDays: days) { result in
            switch result {
            case .success(let entries):
                self.priceArray = entries.prices
            case .failure(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func createGraph() {
        let lineChartView = LineChartView(frame: CGRect(x: 0, y: 0,
                                                        width: self.graphView.frame.width,
                                                        height: self.graphView.frame.height))
        self.graphView.addSubview(lineChartView)
        
        var graphEntries:[ChartDataEntry] = []
        var i: Int = 1
        for price in self.priceArray {
            if i%1 == 0 {
                let entry = ChartDataEntry(x: price[0], y: price[1])
                graphEntries.append(entry)
            }
            i = i + 1
        }
        
        let dataSet = LineChartDataSet(entries: graphEntries)
        
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .horizontalBezier
        dataSet.lineWidth = 2
        dataSet.cubicIntensity = 0.01
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        dataSet.highlightLineWidth = 3
        dataSet.setColor(.nephritis)
    
        
        let gradientColors = [UIColor.nephritis.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
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
}

extension PortfolioViewController: AxisValueFormatter, ChartViewDelegate {
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
       return Date(timeIntervalSince1970: value/1000).stringForGraph(forDays: graphTimeInterval)
    }
}
                                   
