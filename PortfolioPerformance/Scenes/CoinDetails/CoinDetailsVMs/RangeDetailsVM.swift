import Foundation
import Charts

enum RangeDetailsViewModelState {
    case loading
    case dataReceived(RangeDetailsViewModel)
}

struct RangeDetailsViewModel {
    
    //MARK: - Private Properties
    
    private let priceModels: [[Double]]
    
    private var chartData: [[Double]] {
        extractPriceSubset(from: priceModels)
    }
    
    private var currentPriceValue: Double {
        priceModels.last?[1] ?? 0
    }
    
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
        convertPricesToChartEntries(priceModels: chartData)
    }
    
    //MARK: - Init
    
    init(priceModels: [[Double]]) {
        self.priceModels = priceModels
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
    
    /// Extracts a subset  from an array of prices. Makes chart look cleaner and less cluttered.
    /// - Parameters:
    ///   - prices: The input array of prices.
    ///   - subsetSize: The number of elements to include in the subset. Defaults to 60.
    /// - Returns:  A new array containing `subsetSize` elements, where each element is taken from the original array at equal intervals.
    private func extractPriceSubset(from prices: [[Double]], subsetSize: Int = 60) -> [[Double]] {
        guard !prices.isEmpty else { return [] }
        guard prices.count > subsetSize else { return prices }
        
        let step = prices.count / subsetSize
        
        return prices.enumerated().reduce(into: []) { subset, enumeratedElement in
            if enumeratedElement.offset % step == 0 {
                subset.append(enumeratedElement.element)
            }
        }
    }
}
