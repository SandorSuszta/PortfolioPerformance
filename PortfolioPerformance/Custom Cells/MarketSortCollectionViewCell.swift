import UIKit

class MarketSortCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "marketSortCell"
    //Configure selected cell
    override var isSelected: Bool {
        didSet {
            sortNameLabel.textColor = isSelected ? .black : .darkGray
            sortCellView.backgroundColor = isSelected ? .systemGray5 : .clear
        }
    }
     
    @IBOutlet var sortNameLabel: UILabel!
    @IBOutlet var sortCellView: UIView!
}
