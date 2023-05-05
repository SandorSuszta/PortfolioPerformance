import UIKit

protocol ImageDownloaderProtocol {
    func loadImage(from imageUrl: String, completion: @escaping (Result<UIImage, PPError>) -> Void)
    func cancelDownload()
}

final class ImageDownloader: ImageDownloaderProtocol {

    private var dataTask: URLSessionDataTask?
    
    func loadImage(from imageUrl: String, completion: @escaping (Result<UIImage, PPError>) -> Void){
        
        if let cachedImage = ImageCacheService.shared.getImage(for: imageUrl) {
            completion(.success(cachedImage))
            return
        } else {
            guard let url = URL(string: imageUrl) else {
                completion(.failure(.invalidUrl))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(.netwokingError))
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    completion(.failure(.invalidData))
                    return
                }
                
                ImageCacheService.shared.setImage(image, for: imageUrl)
                
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
            dataTask?.resume()
        }
    }
    
    func cancelDownload() {
        dataTask?.cancel()
        dataTask = nil
    }
}
