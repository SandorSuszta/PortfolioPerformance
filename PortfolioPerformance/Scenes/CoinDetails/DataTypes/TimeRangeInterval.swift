import Foundation

/// Represents various time range intervals
enum TimeRangeInterval: CaseIterable {
    
    case day, week, month, sixMonth, year, max
    
    /// Returns the name of the range interval.
    var rangeName: String {
        switch self {
        case .day: return "Day range"
        case .week: return "Week range"
        case .month: return "Month range"
        case .sixMonth: return "Six month range"
        case .year: return "Year range"
        case .max: return "All time range"
        }
    }
    
    /// Returns the name of the range interval for display in segmented controls.
    var segmentName: String {
        switch self {
        case .day: return "1D"
        case .week: return "1W"
        case .month: return "1M"
        case .sixMonth: return "6M"
        case .year: return "1Y"
        case .max: return "MAX"
        }
    }
    
    /// Returns the number of days in the range interval.
    var numberOfDays: Int {
        switch self {
        case .day: return 1
        case .week: return 7
        case .month: return 30
        case .sixMonth: return 180
        case .year: return 364
        case .max: return 364 * 100
        }
    }
}
