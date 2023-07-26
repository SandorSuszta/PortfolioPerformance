import UIKit

extension UINavigationController {
    func showAlert(message: String, retryHandler: ErrorAlertDelegate) {
        DispatchQueue.main.async {
            let alert = ErrorAlertVC (text: message)
            alert.delegate = retryHandler
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen
            self.present(alert, animated: true)
        }
    }
}
