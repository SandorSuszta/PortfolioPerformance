import Foundation

protocol ImagesRepository: Cancellable {
    
    func getImageData(
        for utlPath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    
    func saveImageData(_ imageData: Data, for urlPath: String)
}
