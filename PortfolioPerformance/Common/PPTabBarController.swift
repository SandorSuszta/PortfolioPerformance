import UIKit

final class PPTabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.tintColor = .PPBlue
        makeTabBarTransparent()
        createTabBarBackgroundLayer()
    }
    
    //MARK: - Private methods
    
    private func createTabBarBackgroundLayer() {
        let layer = CAShapeLayer()
        
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: tabBar.bounds.minY, width: tabBar.bounds.width, height: tabBar.bounds.height + 50), cornerRadius: 25).cgPath
        layer.shadowColor = UIColor.systemGray6.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.secondarySystemBackground.cgColor

        tabBar.layer.insertSublayer(layer, at: 0)
    }
    
    private func makeTabBarTransparent() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.isTranslucent = true
    }
}

extension PPTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController === viewController {
            guard let navigationController = viewController as? UINavigationController,
                  let handler = navigationController.viewControllers.first as? TabBarReselectHandler else { return true }
            handler.handleReselect()
        }
        return true
    }
}
