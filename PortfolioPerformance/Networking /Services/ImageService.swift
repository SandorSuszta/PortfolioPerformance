import UIKit

protocol ImageServiceProtocol {
    
    func loadImage(from imageUrl: String, completion: @escaping (Result<(ImageSource, UIImage), PPError>) -> Void)
    
    func cancelDownload()
}

final class ImageService: ImageServiceProtocol {

    private var dataTask: URLSessionDataTask?
    
    func loadImage(from imageUrl: String, completion: @escaping (Result<(ImageSource, UIImage), PPError>) -> Void) {
        
        if let image = ImageCache.shared.getImage(for: imageUrl) {
            completion(.success((.cached, image)))
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
                    completion(.success((.downloaded, image)))
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
