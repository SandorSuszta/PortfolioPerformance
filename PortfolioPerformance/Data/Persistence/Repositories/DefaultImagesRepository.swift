import Foundation

final class DefaultImageRepository: ImageRepository {
    private let httpClient: HTTPClient
    private let imagesCache: ImagesStorage
    
    // MARK: - Init
    
    init(httpClient: HTTPClient, imagesCache: ImagesStorage) {
        self.httpClient = httpClient
        self.imagesCache = imagesCache
    }
    
    // MARK: - API
    
    func getImageData(for urlPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        if let data = imagesCache.getImageData(for: urlPath) {
            completion(.success(data))
        } else {
            
            let url = URL(string: urlPath)
            
            httpClient.performRequest(
                url: url,
                responseType: Data.self,
                completionHandler: completion
            )
        }
    }
    
    func saveImageData(_ imageData: Data, for urlPath: String) {
        imagesCache.save(imageData, for: urlPath)
    }
}
