import Foundation

///This protocol defines the requirements for a view controller to handle double click event on a tabbar icon. (Usually scroll its content to the top when the corresponding tab bar item is double-clicked).
protocol TabBarReselectHandler: AnyObject {
    func handleReselect()
}
