import UIKit

protocol SortSectionHeaderDelegate: AnyObject {
    func didSelectSortOption(_ sortOption: CryptoCurrenciesSortOption)
}

final class SortSectionHeader: UICollectionReusableView {
    
    static let reuseID = String(describing: SortSectionHeader.self)
    static let prefferedHeight: CGFloat = 44
   
    //MARK: - Delegate
    
    weak var delegate: SortSectionHeaderDelegate?
    
    //MARK: - UI Elements
    
    private lazy var sortOptionsCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .red //!!!!!!!!!
        return collectionView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupCollectionViewLayout() {
        
        addSubview(sortOptionsCollectionView)
        sortOptionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortOptionsCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortOptionsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortOptionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sortOptionsCollectionView.heightAnchor.constraint(equalToConstant: SortSectionHeader.prefferedHeight)
        ])
    }
}
