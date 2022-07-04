//
//  [New]MarketViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/06/2022.
//

import UIKit

class _New_MarketViewController: UIViewController {
    
    //MARK: - Properties
    
    let marketCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(
            MarketCardsCollectionViewCell.self,
            forCellWithReuseIdentifier: MarketCardsCollectionViewCell.identifier
        )
        return collection
        
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMarketCardsCollectionView()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        marketCardsCollectionView.frame = CGRect(
            x: 0,
            y: 100,
            width: view.width,
            height: 200
        )
    }
    
    //MARK: - Methods
    
    private func setupMarketCardsCollectionView() {
        marketCardsCollectionView.delegate = self
        marketCardsCollectionView.dataSource = self
        view.addSubview(marketCardsCollectionView)
    }
}
    
    //MARK: - Collection View methods

extension _New_MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = marketCardsCollectionView.dequeueReusableCell(
            withReuseIdentifier: MarketCardsCollectionViewCell.identifier,
            for: indexPath
        ) as? MarketCardsCollectionViewCell else { return UICollectionViewCell() }
        cell.configureWithShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.width/2 - 70, height: (view.width/2 - 40) )
    }
    
    //Distance between the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    //Left inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    
}

