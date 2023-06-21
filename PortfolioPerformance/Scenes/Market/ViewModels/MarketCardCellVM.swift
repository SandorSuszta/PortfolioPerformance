import UIKit

/// A view model is designed to work with specific cell types defined in the `MarketCardCell` enum.
/// The view model assumes that the `UIColor` extension with color properties like `.nephritis`, `.pomergranate`, etc., is available.
///
final class MarketCardCellViewModel {
    
    private let id = UUID()
    
    let cellType: MarketCardCell
    
    let mainMetricValue: String
    
    let secondaryMetricValue: String
    
    var secondaryMetricTextColor: UIColor {
        switch cellType {
        case .greedAndFear:
            return colorForIndexValue(mainMetricValue)
        case .totalMarketCap, .bitcoinDominance:
            return (isChangePositive ?? true) ? .nephritis : .pomergranate
        }
    }
    
    let progressValue: Float
    
    let isChangePositive: Bool?
    
    //MARK: - Init
    
    init(cellType: MarketCardCell, mainMetricValue: String, secondaryMetricValue: String, progressValue: Float, isChangePositive: Bool? = nil) {
        self.cellType = cellType
        self.mainMetricValue = mainMetricValue
        self.secondaryMetricValue = secondaryMetricValue
        self.progressValue = progressValue
        self.isChangePositive = isChangePositive
    }
    
    //MARK: - Private methods
    
    /// Returns the color for the secondary metric value based on the change being positive or negative.
    private func secondaryMetricColor() -> UIColor {
        (isChangePositive ?? true) ? .nephritis : .pomergranate
    }
    
    ///  Returns the color for the Greed & Fear index.
    private func colorForIndexValue(_ value: String) -> UIColor {
        switch Int(value) ?? 0 {
        case 0...20:
            return .pomergranate
        case 21...40:
            return .alizarin
        case 41...60:
            return .carrot
        case 60...80:
            return .emerald
        case 81...100:
            return .nephritis
        default:
            return .clear
        }
    }
}

extension MarketCardCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: MarketCardCellViewModel, rhs: MarketCardCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
