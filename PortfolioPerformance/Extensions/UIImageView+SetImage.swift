//
//  UIImageView+SetImage.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 18/05/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(imageUrl: String) {
        if let cachedImage = NetworkingManager.shared.cache.object(forKey: NSString(string: imageUrl)) {
            image = cachedImage
        } else {
            guard let url = URL(string: imageUrl) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
                guard let data = data, error == nil else { return }
                
                if let downloadedImage = UIImage(data: data) {
                    NetworkingManager.shared.cache.setObject(
                        downloadedImage,
                        forKey: NSString(string: imageUrl)
                    )
                }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
