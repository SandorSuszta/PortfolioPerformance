import UIKit

final class ImageDownloader {
    static let shared = ImageDownloader()
    
    private init() {}
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from imageUrl: String, completion: @escaping (Result<UIImage, PPError>) -> Void) -> URLSessionDataTask? {
        if let cachedImage = imageCache.object(forKey: NSString(string: imageUrl)) {
            completion(.success(cachedImage))
            return nil
        } else {
            guard let url = URL(string: imageUrl) else {
                completion(.failure(.invalidUrl))
                return nil
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(.netwokingError))
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    completion(.failure(.invalidData))
                    return
                }
                
                self?.imageCache.setObject(image, forKey: NSString(string: imageUrl))
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
            task.resume()
            return task
        }
    }
}
