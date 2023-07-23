import UIKit

protocol SortSectionHeaderDelegate: AnyObject {
    func didSelectSortOption(_ sortOption: MarketSortOption)
}

final class SortSectionHeader: UICollectionReusableView {
    
    static let reuseID = String(describing: SortSectionHeader.self)
    static let prefferedHeight: CGFloat = 44
    
    private var sortOptions: [MarketSortOption] = []
   
    //MARK: - Delegate
    
    weak var delegate: SortSectionHeaderDelegate?
    
    //MARK: - UI Elements
    
    private lazy var sortOptionsCollectionView: UICollectionView  = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SortOptionsCell.self, forCellWithReuseIdentifier: SortOptionsCell.reuseID)
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        return collectionView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        sortOptions = makeCollectionDaraSource()
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
            sortOptionsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            sortOptionsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortOptionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sortOptionsCollectionView.heightAnchor.constraint(equalToConstant: SortSectionHeader.prefferedHeight)
        ])
    }
    
    private func makeCollectionDaraSource() -> [MarketSortOption] {
        var dataSource: [MarketSortOption] = []
        MarketSortOption.allCases.forEach { dataSource.append($0) }
        return dataSource
    }
    
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        //Configure Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1/4),
            heightDimension: .fractionalHeight(0.9)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        //Configure Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        group.interItemSpacing = .fixed(8)
        
        //Configure Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension SortSectionHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sortOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = sortOptionsCollectionView.dequeueReusableCell(
            withReuseIdentifier: SortOptionsCell.reuseID,
            for: indexPath
        ) as? SortOptionsCell else { return UICollectionViewCell() }
        
        cell.setTitle(sortOptions[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelectSortOption(sortOptions[indexPath.row])
    }
}
