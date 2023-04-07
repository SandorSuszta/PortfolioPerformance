import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: url))
    }
    
    func setImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: NSString(string: url))
    }
}
