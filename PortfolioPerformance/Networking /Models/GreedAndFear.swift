import Foundation
/* API response example
 {
     "name": "Fear and Greed Index",
     "data": [
         {
             "value": "25",
             "value_classification": "Extreme Fear",
             "timestamp": "1645574400",
             "time_until_update": "5500"
         }
     ],
     "metadata": {
         "error": null
     }
 } */
 
struct GreedAndFear: Codable {
    let name: String
    let data: [Index]
}

// MARK: - Index
struct Index: Codable {
    let value, valueClassification: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case valueClassification = "value_classification"
    }
}
