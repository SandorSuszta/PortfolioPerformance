//
//  UIViewController+ShowAlert.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 06/10/2022.
//

import UIKit

extension UIViewController {
    public func showAlert(message: String) {
        let alert = CustomAlertVC (text: message)
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
