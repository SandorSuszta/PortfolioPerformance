//
//  GreedAndFearModel.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 24/02/2022.
//

import Foundation

struct GreedAndFearModel: Codable {
    
   /* {
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
