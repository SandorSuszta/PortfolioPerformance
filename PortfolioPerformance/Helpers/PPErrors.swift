//
//  UIHelper.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 03/10/2022.
//

enum PPError: String, Error {
    case netwokingError = "Server is not responding"
    case decodingError = "Invalid data from the server"
    case invalidUrl = "The requested URL is invalid"
}
