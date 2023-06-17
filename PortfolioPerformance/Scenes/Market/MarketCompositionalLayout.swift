import UIKit

/// A custom compositional layout for Market tab.
/// Displays a collection view with two sections: "Market Cards" and "Crypto Coins". The "Market Cards" section displays items in a horizontal scrolling layout, while the "Crypto Coins" section displays items in a vertical layout.
/// To use this layout, initialize an instance of `MarketCompositionalLayout` and assign it to the `collectionViewLayout` property of your `UICollectionView` instance.
final class MarketCompositionalLayout: UICollectionViewCompositionalLayout {
    
    //MARK: - Init
    
    /// The initializer sets up the layout by defining the sections and their layouts based on the section index.
    init() {
        super.init { sectionIndex, _ in
            let sections =  [
                MarketCompositionalLayout.makeMarketCardsSection(),
                MarketCompositionalLayout.makeCryptoCoinsSection()
            ]
            return sections[sectionIndex]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    //MARK: - Section Factory Methods

private extension MarketCompositionalLayout {
    
    /// Creates and returns the layout for the "Market Cards" section.
    ///
    /// The "Market Cards" section displays items in a horizontal scrolling layout.
    static func makeMarketCardsSection() -> NSCollectionLayoutSection {
      
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
    
    /// Creates and returns the layout for the "Crypto Coins" section.
    ///
    /// The "Crypto Coins" section displays items in a vertical layout.
    static func makeCryptoCoinsSection() -> NSCollectionLayoutSection {
    
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
