//
//  UIColor+CustomColors.swift
//  PortfolioPerformance
import UIKit

extension UIColor {
    static let nephritis = UIColor(red: 0.11, green: 0.77, blue: 0.49, alpha: 1.00)
    static let pomergranate = UIColor(red: 0.94, green: 0.33, blue: 0.31, alpha: 1.00)
    static let alizarin = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
    static let carrot = UIColor(red: 1.00, green: 0.67, blue: 0.25, alpha: 1.00)
    static let emerald = UIColor(red: 153/255, green: 204/255, blue: 153/255, alpha: 1)
    static let clouds = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
    static let darkClouds = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let pinkGlamour = UIColor(red: 255/255, green: 153/255, blue: 153/255, alpha: 1)
    static let lightIndigo = UIColor(red: 230/255, green: 237/255, blue: 243/255, alpha: 1)
    static let lightOrange = UIColor(red: 255/255, green: 249/255, blue: 235/255, alpha: 1)
    static let lightBrown = UIColor(red: 240/255, green: 237/255, blue: 232/255, alpha: 1)
    static let navy = UIColor(red: 0.01, green: 0.66, blue: 0.96, alpha: 1.00)
    static let PPblue = UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1.00)
    
    static var PPSystemBackground: UIColor = {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ? .systemBackground : .secondarySystemBackground
        }
    }()

    static var PPSecondarySystemBackground: UIColor = {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ? .secondarySystemBackground : .systemBackground
        }
    }()
}

