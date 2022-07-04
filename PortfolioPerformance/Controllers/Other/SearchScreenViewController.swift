//
//  SearchViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 05/05/2022.
//

import Foundation
import UIKit

protocol SearchViewControllerDelegate {
    func didSelectCoin(coinName: String)
}

enum RootViewControllersForSearch {
    case marketTableView
    case transactionDetails
}

class SearchScreenViewController: UIViewController {
    
    public var delegate: SearchViewControllerDelegate?
    
    public var rootViewController: RootViewControllersForSearch?
    
    private var searchResultsArray: [SearchResult] = [SearchResult(id: "", name: "Bitcoin", symbol: "BTC", large: "")]
    
    let resultsTableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.backgroundColor = .systemGray6
        table.register(
            ResultsTableViewCell.self,
            forCellReuseIdentifier: ResultsTableViewCell.identifier
        )
        return table
    }()
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpResultsTableVIew()
        setUpTitleView()
        setUpSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsTableView.frame = view.bounds
    }
    
    //MARK: - Private
    private func setUpSearchController() {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpTitleView() {
        
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: navigationController?.navigationBar.height ?? 100
            )
        )
    
        let label = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: titleView.width,
                height: titleView.height
            )
        )
        label.text = "Select Coin"
        label.font = .systemFont(ofSize: 28, weight: .medium)
        
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func setUpResultsTableVIew() {
        view.addSubview(resultsTableView)
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
}

    //MARK: - TableView delegate methods
extension SearchScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = resultsTableView.dequeueReusableCell(
            withIdentifier: ResultsTableViewCell.identifier,
            for: indexPath
        ) as? ResultsTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: searchResultsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rootViewController {
        case .transactionDetails:
            delegate?.didSelectCoin(coinName: searchResultsArray[indexPath.row].symbol)
            navigationController?.popViewController(animated: true)
        case .marketTableView:
            fatalError()
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ResultsTableViewCell.preferedHeight
    }
}

    //MARK: - Results Updating methods
extension SearchScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Check if not empty
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        APICaller.shared.searchForCoin(query: query) { result in
            switch result {
            case .success(let response):
                self.searchResultsArray = response.coins
                DispatchQueue.main.async {
                    self.resultsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
}
    
