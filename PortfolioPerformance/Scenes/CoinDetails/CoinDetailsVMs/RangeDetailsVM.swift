import Foundation
import Charts

enum RangeDetailsViewModelState {
    case loading
    case dataReceived(RangeDetailsViewModel)
}

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
    
    var priceChange: String {
        .priceString(from: priceChangeValue)
    }
    
    var priceChangePercentage: String {
        let percentage = ((priceModels.last?[1] ?? 0) / (priceModels.first?[1] ?? 0) - 1) * 100
        return "(" + .percentageString(from: percentage) + ")"
    }
    
    var rangeLow: String {
        .priceString(from: lowestPriceValue)
    }
    
    var rangeHigh: String {
        .priceString(from: highestPriceValue)
    }
    
    var percentageFromLow: String {
        let percentage = (currentPriceValue/lowestPriceValue - 1) * 100
        return .percentageString(from: percentage)
    }
    
    var percentageFromHigh: String {
        let percentage = (currentPriceValue/highestPriceValue - 1) * 100
        return .percentageString(from: percentage)
    }
    
    var progress: Float {
        Float((currentPriceValue - lowestPriceValue) / (highestPriceValue - lowestPriceValue))
    }
    
    var isChangePositive: Bool {
        priceChangeValue >= 0 ? true : false
    }
    
    var chartEntries: [ChartDataEntry] {
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
