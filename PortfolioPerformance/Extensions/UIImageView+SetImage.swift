import UIKit

extension UIImageView {
    func setImage(from imageUrl: String) {
        if let cachedImage = NetworkingService.shared.cache.object(forKey: NSString(string: imageUrl)) {
            image = cachedImage
        } else {
            guard let url = URL(string: imageUrl) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
                guard let data = data, error == nil else { return }
                
                if let downloadedImage = UIImage(data: data) {
                    NetworkingService.shared.cache.setObject(
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
