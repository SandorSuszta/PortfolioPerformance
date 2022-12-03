import Foundation

extension String {
    
    static func priceString(from number: Double) -> String {
        
        guard number != 0 else { return "N/A"}
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        
        if number >= 1 || number <= -1 {
            formatter.maximumFractionDigits = 2
        } else {
            // Number of zeros between the decimal point and first non zero digit
            let numberOfDigits = ceil(abs(log10(abs(number)))) + 2
            
            //Guard the error converting to Int
            guard !(numberOfDigits.isNaN || numberOfDigits.isInfinite) else {
                return  "N/A"
             }
            formatter.maximumFractionDigits = Int(numberOfDigits)
        }
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    static func percentageString(from number: Double, positivePrefix: String = "+") -> String {
        
        guard number != 0 else { return "N/A"}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = positivePrefix
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: number / 100)) ?? ""
    }
    
    static func bigNumberString(from number: Double, style: NumberFormatter.Style = .currency ) -> String {
        
        guard number != 0 else { return "N/A"}
        
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        var formattedNumber: Double = 0
        
        switch number {
        case 1000...999999:
            formatter.positiveSuffix = " K"
            formattedNumber = number / 1000
        case 1000000...999999999:
            formatter.positiveSuffix = " M"
            formattedNumber = number / 1000000
        case 10000000000...999999999999:
            formatter.positiveSuffix = " B"
            formattedNumber = number / 1000000000
        case 999999999999...:
            formatter.positiveSuffix = " T"
            formatter.maximumFractionDigits = 2
            formattedNumber = number / 1000000000000
            formatter.maximumFractionDigits = 2
            
        default:
            formattedNumber = number
        }
        return formatter.string(from: NSNumber(value: formattedNumber)) ?? ""
    }
    
    static func stringForGraphAxis(from date: Date, daysInterval: Int) -> String {
        let formatter = DateFormatter()
        
        switch daysInterval {
        case 1:
            formatter.dateFormat = "HH:mm"
        case 7, 30:
            formatter.dateFormat = "d MMM"
        case 180, 360:
            formatter.dateFormat = "MMM yy"
        case 2000:
            formatter.dateFormat = "yyyy"
        default: fatalError()
        }
        return formatter.string(from: date)
    }
    
    static func formatedDateString(fromISO date: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        
        guard let convertedDate = isoFormatter.date(from: date) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: convertedDate)
    }
    
    static func formatedStringForATHDate(fromUTC date: String) -> String {
        let utcToDateFormater = DateFormatter()
        utcToDateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let convertedDate  = utcToDateFormater.date(from: date) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        let formatedDate = formatter.string(from: convertedDate)
        let daysSince = Int(Date().timeIntervalSince(convertedDate) / (60 * 60 * 24))
        
        return formatedDate + " (\(daysSince) days ago)"
    }
}

