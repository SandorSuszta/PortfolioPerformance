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
        
        register(RoundedBackgroundView.self, forDecorationViewOfKind: RoundedBackgroundView.reuseID)
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
      
        //Configure Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        //Configure group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95 * 3/2),
            heightDimension: .fractionalHeight(0.22)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        group.interItemSpacing = .fixed(16)
        
        //Configure section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
    
    /// Creates and returns the layout for the "Crypto Coins" section.
    ///
    /// The "Crypto Coins" section displays items in a vertical layout.
    static func makeCryptoCoinsSection() -> NSCollectionLayoutSection {
        
        //Configure Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(CryptoCurrencyCell.prefferredHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        //Configure Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(CryptoCurrencyCell.prefferredHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        //Configure Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(48))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerElement.pinToVisibleBounds = true
        
        //BackgroundView
        let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.reuseID)
        
        //Configure Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement]
        section.decorationItems = [backgroundView]
        
        return section
    }
}
