import UIKit

class SearchScreenViewController: UIViewController {

    private var viewModel = SearchScreenViewModel()
    
    private var searchTimer: Timer?
    
    private var isSearching: Bool = false
    
    lazy var searchBar = UISearchBar()
    
    private let resultsTableView: UITableView = {
        let table = UITableView()
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
        setUpSearchBar()
        bindViewModels()
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateRecentSearches()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsTableView.frame = view.bounds
    }
    
    //MARK: - Private
    
    private func setUpSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setUpResultsTableVIew() {
        view.addSubview(resultsTableView)
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.sectionHeaderTopPadding = 0
    }
    
    private func bindViewModels() {
        
        viewModel.searchResultCellModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
            }
        }
        
        viewModel.defaultCellModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard let message = message else { return }
            
            self?.showAlert(message: message)
        }
    }
}

    //MARK: - TableView data source methods

extension SearchScreenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        isSearching ? 1 : viewModel.defaultCellModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        isSearching ? viewModel.searchResultCellModels.value?.count ?? 0 : viewModel.defaultCellModels.value?[section].count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = resultsTableView.dequeueReusableCell(
            withIdentifier: ResultsTableViewCell.identifier,
            for: indexPath
        ) as? ResultsTableViewCell else { return UITableViewCell() }
        
        if let searchResults = viewModel.searchResultCellModels.value {
            
            cell.configure(with: searchResults[indexPath.row])
            
        } else {
            
            guard let model = viewModel.defaultCellModels.value?[indexPath.section][indexPath.row] else { return UITableViewCell() }
            
            cell.configure(with: model)
        }
        
        return cell
    }
}
    
    //MARK: - TableView delegate methods
    
extension SearchScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            return nil
        } else {
            
            let recentSearchesHeader = PPSectionHeaderView(type: .recentSearches, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
            
            recentSearchesHeader.buttonAction = { [weak self] in
                self?.viewModel.clearRecentSearches()
                UserDefaultsManager.shared.clearRecentSearchesIDs()
            }
            
            let trendingCoinsHeader = PPSectionHeaderView(type: .trendingCoins, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
            
            return UserDefaultsManager.shared.recentSearchesIDs.isEmpty ? trendingCoinsHeader : [recentSearchesHeader, trendingCoinsHeader][section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        isSearching ? 0 : PPSectionHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var model: SearchResult?
        
        if let searchResults = viewModel.searchResultCellModels.value {
            model = searchResults[indexPath.row]
        } else {
            model = viewModel.defaultCellModels.value?[indexPath.section][indexPath.row]
        }
        
        guard let model = model else { return }
       
        searchBar.text = ""
        isSearching = false
        viewModel.clearSearchModels()
        
        UserDefaultsManager.shared.saveToDefaults(
            ID: model.id,
            forKey: UserDefaultsManager.shared.recentSearchesKey
        )
        
        let detailVC = CoinDetailsVC(
            coinID: model.id,
            coinName: model.name,
            coinSymbol: model.symbol,
            logoURL: model.large,
            isFavourite: UserDefaultsManager.shared.isInWatchlist(id: model.id)
        )
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ResultsTableViewCell.preferredHeight
    }
}

    //MARK: - Results Updating methods
extension SearchScreenViewController: UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let query = searchBar.text,
           !query.trimmingCharacters(in: .whitespaces).isEmpty
        {
            isSearching = true
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.viewModel.updateSearchResults(query: query)
            }
        } else {
            isSearching = false
            viewModel.clearSearchModels()
        }
    }    
}
    
