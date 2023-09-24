import Foundation

final class NSCacheImageStorage: ImagesStorage {
    private let imageCache = {
        let cache = NSCache<NSString, NSCacheData>()
        cache.countLimit = 300
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()
    
    func getImageData(for urlPath: String) -> Data? {
        let cacheObject = imageCache.object(forKey: NSString(string: urlPath))
        return cacheObject?.value
    }
    
    func save(_ imageData: Data, for urlPath: String) {
        let cacheObject = NSCacheData(imageData)
        imageCache.setObject(cacheObject, forKey: NSString(string: urlPath))
    }
}


///Class wrapper for Data, to comply with NSCache
final class NSCacheData {
    let value: Data
    
    init(_ value: Data) {
        self.value = value
    }
}
