import Foundation

protocol ImagesStorage {
    func getImageData(for urlPath: String) -> Data?
    func save(_ imageData: Data, for urlPath: String)
}
