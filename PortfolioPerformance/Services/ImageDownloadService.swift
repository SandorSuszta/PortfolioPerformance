import UIKit

protocol ImageDownloadProtocol {
    func loadImage(from imageUrl: String, completion: @escaping (Result<UIImage, PPError>) -> Void)
    func cancelDownload()
}

final class ImageDownloadService: ImageDownloadProtocol {
    private var imageCache = NSCache<NSString, UIImage>()
    private var task: URLSessionDataTask?
    
    func loadImage(from imageUrl: String, completion: @escaping (Result<UIImage, PPError>) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: imageUrl)) {
            completion(.success(cachedImage))
        } else {
            guard let url = URL(string: imageUrl) else {
                completion(.failure(.invalidUrl))
                return
            }
            
            task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                
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
            task?.resume()
        }
    }
    
    func cancelDownload() {
        task?.cancel()
    }
}
