import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Change font of NavBar Titles
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(ofSize: 26)]
        
        // Change Back Button color
        UINavigationBar.appearance().tintColor = .PPblue
            
        return true
    }
}

