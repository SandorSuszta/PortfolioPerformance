import UIKit

protocol ImageCacheProtocol {
    func getImage(for url: String) -> UIImage?
    func setImage(_ image: UIImage, for url: String)
}

final class ImageCache: ImageCacheProtocol {
    
    static let shared = ImageCache()
    
    private let imageCache = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 300
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()
    
    private init() {}
    
    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: url))
    }
    
    func setImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: NSString(string: url))
    }
}
