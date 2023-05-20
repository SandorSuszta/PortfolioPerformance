import UIKit

extension UINavigationController {
    public func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = CustomAlertVC (text: message)
            alert.modalTransitionStyle = .crossDissolve
            alert.modalPresentationStyle = .overFullScreen
            self.present(alert, animated: true)
        }
    }
}
