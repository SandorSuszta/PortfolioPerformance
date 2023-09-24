import Foundation

protocol ImageRepository {
    
    func getImageData(
        for utlPath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    
    func saveImageData(_ imageData: Data, for urlPath: String)
}
