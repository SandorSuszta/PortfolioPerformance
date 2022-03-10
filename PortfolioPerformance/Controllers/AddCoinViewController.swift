//
//  AddCoinViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 14/02/2022.
//

import UIKit

class AddCoinViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchCoinTextField: UISearchBar!
    @IBOutlet weak var addCoinCollectionView: UICollectionView!
    
    public var collectionViewCoins = [CoinModel]()
    private let segueIdentifier = "addCoinToAddTransaction"
    private let cellIdentifier = "addCoinCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMarketData()
        
        addCoinCollectionView.dataSource = self
        addCoinCollectionView.delegate = self
        
    }
    
    private func loadMarketData() {
        APICaller.shared.getMarketData { result in
            switch result {
                
            case .success(let coinArray):
                self.collectionViewCoins = coinArray
                
                DispatchQueue.main.async {
                    self.addCoinCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewCoins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AddCoinCollectionViewCell
        
        cell.nameLabel.text = collectionViewCoins[indexPath.row].name
        cell.symbolLabel.text = collectionViewCoins[indexPath.row].symbol.uppercased()
        
        // Set image
        
        if let imageData = self.collectionViewCoins[indexPath.row].imageData {
            cell.logoImage.image = UIImage(data: imageData)
        } else {
            if let url = URL(string: collectionViewCoins[indexPath.row].image) {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        self.collectionViewCoins[indexPath.row].imageData = data
                        DispatchQueue.main.async {
                            cell.logoImage.image = UIImage(data: data)
                        }
                    } else {
                        print("Error getting image")
                    }
                }
                task.resume()
            }
        }
        
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = .zero
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5.0
        cell.layer.masksToBounds = false
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}



extension AddCoinViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (view.frame.width - 40)/4,
            height: (view.frame.width - 40)/4 * 1.4
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    

}
