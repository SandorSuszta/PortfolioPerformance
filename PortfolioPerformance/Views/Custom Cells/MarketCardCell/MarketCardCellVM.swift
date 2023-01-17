import UIKit

struct MarketCardCellViewModel {
    
    public let cellType: MarketCardCellType
    
    public let mainMetricValue: String
    
    public let secondaryMetricValue: String
    
    public let progressValue: Float
    
    public let isChangePositive: Bool? = true
    
    public var secondaryMetricTextColor: UIColor {
        switch cellType {
        case .greedAndFear:
            return determineColorBasedOn(indexValue: Int(mainMetricValue) ?? 0)
        case .totalMarketCap, .bitcoinDominance:
            return isChangePositive ?? true ? .nephritis : .pomergranate
        }
    }
    
    private func determineColorBasedOn(indexValue: Int) -> UIColor {
        switch indexValue {
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
