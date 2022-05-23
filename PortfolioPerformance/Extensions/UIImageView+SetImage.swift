//
//  UIImageView+SetImage.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 18/05/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(from imageUrl: String) {
        
        guard let url = URL(string: imageUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
