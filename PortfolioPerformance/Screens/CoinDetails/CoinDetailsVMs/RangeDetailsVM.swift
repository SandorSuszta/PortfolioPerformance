import Foundation
import Charts

struct RangeDetailsViewModel {
    
    //MARK: - Private Properties
    
    private let priceModels: [[Double]]
    
    private let currentPriceValue: Double
    
    private var lowestPriceValue: Double {
        let minPriceModel = priceModels.min { $0[1] < $1[1] }
        return minPriceModel?[1] ?? 0
    }
    
    private var highestPriceValue: Double {
        let maxPriceModel = priceModels.max { $0[1] < $1[1] }
        return maxPriceModel?[1] ?? 0
    }
    
    private var priceChangeValue: Double {
        (priceModels.last?[1] ?? 0) - (priceModels.first?[1] ?? 0)
    }
    
    //MARK: - Public properties
    
    public var priceChange: String {
        .priceString(from: priceChangeValue)
    }
    
    public var priceChangePercentage: String {
        let percentage = ((priceModels.last?[1] ?? 0) / (priceModels.first?[1] ?? 0) - 1) * 100
        return .percentageString(from: percentage)
    }
    
    public var rangeLow: String {
        .priceString(from: lowestPriceValue)
    }
    
    public var rangeHigh: String {
        .priceString(from: highestPriceValue)
    }
    
    public var percentageFromLow: String {
        let percentage = (currentPriceValue/lowestPriceValue - 1) * 100
        return .percentageString(from: percentage)
    }
    
    public var percentageFromHigh: String {
        let percentage = (currentPriceValue/highestPriceValue - 1) * 100
        return .percentageString(from: percentage)
    }
    
    public var progress: Float {
        Float((currentPriceValue - lowestPriceValue) / (highestPriceValue - lowestPriceValue))
    }
    
    public var isChangePositive: Bool {
        priceChangeValue >= 0 ? true : false
    }
    
    public var chartEntries: [ChartDataEntry] {
        convertPricesToChartEntries(priceModels: priceModels)
    }
    
    //MARK: - Init
    
    init(priceModels: [[Double]], currentPriceValue: Double ) {
        self.priceModels = priceModels
        self.currentPriceValue = currentPriceValue
    }
    
    //MARK: - Private methods
    
    private func convertPricesToChartEntries(priceModels: [[Double]]) -> [ChartDataEntry] {
        var chartDataEntries: [ChartDataEntry] = []
        for priceModel in priceModels {
            let entry = ChartDataEntry(x: priceModel[0], y: priceModel[1])
            chartDataEntries.append(entry)
        }
        return chartDataEntries
    }
}
