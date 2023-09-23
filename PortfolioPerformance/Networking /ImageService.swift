import UIKit

protocol ImageServiceProtocol {
    
    func fetchImage(for imageUrl: String, completion: @escaping (Result<(ImageSource, UIImage), PPError>) -> Void)
    
    func cancelFetching()
}

protocol ImageRepository {
    func fetchImage(for imageUrl: String) -> UIImage?
    func saveImage(_ image: UIImage, for imageUrl: String)
}

final class NSCacheImageRepository: ImageRepository {
    
    private let imageCache = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 300
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()
    
    func fetchImage(for imageUrl: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: imageUrl))
    }
    
    func saveImage(_ image: UIImage, for imageUrl: String) {
        imageCache.setObject(image, forKey: NSString(string: imageUrl))
    }
}



final class ImageService: ImageServiceProtocol {
    private let repository: ImageRepository
    private let httpClient: HTTPClientProtocol
    
    init(repository: ImageRepository, httpClient: HTTPClientProtocol) {
        self.repository = repository
        self.httpClient = httpClient
    }
    
    // MARK: - API
    
    func fetchImage(for imageUrl: String, completion: @escaping (Result<(ImageSource, UIImage), Error>) -> Void) {
        httpClient.performRequest(url: imageUrl, responseType: (ImageSource, UIImage), completionHandler: completion)
    }
    
    func cancelFetching() {
        httpClient.cancelRequest()
    }
    
    func loadImage(from imageUrl: String, completion: @escaping (Result<ImageSource, PPError>) -> Void) {
        
        
        if let image = repository.fetchImage(for: imageUrl) {
            completion(.success(.cached(image: image)))
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
                
                ImageCache.shared.setImage(image, for: imageUrl)
                
                DispatchQueue.main.async {
                    completion(.success(.downloaded(image: image)))
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
