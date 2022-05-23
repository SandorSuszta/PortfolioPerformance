//
//  UIView+Addsubviews.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 18/05/2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews (_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
