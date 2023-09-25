import Foundation

protocol GreedAndFearService {
    func getGreedAndFearData(completion: @escaping (Result<GreedAndFearResponse, Error>) -> Void)
}
