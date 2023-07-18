import Foundation

enum CryptoCoinCell: Hashable {
    case loading(index: Int)
    case dataReceived(CryptoCurrencyCellViewModel)
}
