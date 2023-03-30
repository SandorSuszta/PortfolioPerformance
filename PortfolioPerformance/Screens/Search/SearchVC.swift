import UIKit

class SearchScreenViewController: UIViewController {

    //MARK: - Properties
    
    enum SearchBarState {
        case searching
        case emptyWithRecents
        case emptyWithoutRecents
    }
    
    private var viewModel = SearchScreenViewModel()
    
    private var searchTimer: Timer?
    
    private var isSearching: Bool = false
    
    private var searchBarState: SearchBarState {
        determineSearchBarState(
            isSearching: isSearching,
            isRecentSearchesEmpty: viewModel.defaultCellModels.value?[0].isEmpty ?? true
        )
    }
    
    lazy private var searchBar = UISearchBar()
    
    private let resultsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.sectionHeaderTopPadding = 0
        table.showsVerticalScrollIndicator = false
        table.separatorColor = .clear
        table.register(
            ResultsCell.self,
            forCellReuseIdentifier: ResultsCell.identifier
        )
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let noResultsView = EmptyStateView(type: .noSearchResults)
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpResultsTableVIew()
        setUpSearchBar()
        setupConstraints()
        bindViewModels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateRecentSearches()
    }
    
    //MARK: - Private
    
    private func setUpViewController() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(noResultsView)
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setUpSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.keyboardType = .asciiCapable
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
    }
    
    private func bindViewModels() {
        
        viewModel.searchResultCellModels.bind { [weak self] _ in
            guard let self else { return }
      
            DispatchQueue.main.async {
                self.resultsTableView.reloadData()
                
                guard let models = self.viewModel.searchResultCellModels.value else {
                    self.noResultsView.isHidden = true
                    return
                }
                
                if models.isEmpty {
                    self.noResultsView.isHidden = false
                }
            }
        }
        
        viewModel.defaultCellModels.bind { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.resultsTableView.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard
                let self = self,
                let message = message
            else {
                return
            }
            
            self.showAlert(message: message)
        }
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            resultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            resultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            noResultsView.heightAnchor.constraint(equalTo: noResultsView.widthAnchor)
        ])
    }
    
    private func determineSearchBarState(isSearching: Bool, isRecentSearchesEmpty: Bool) -> SearchBarState {
        
        switch (isSearching, isRecentSearchesEmpty) {
        case (true, _):
            return .searching
        case (false, false):
            return .emptyWithRecents
        case (false, true):
            return .emptyWithoutRecents
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
            withIdentifier: ResultsCell.identifier,
            for: indexPath
        ) as? ResultsCell else { return UITableViewCell() }
        
        var model: SearchResult?
        
        if isSearching {
            model = viewModel.searchResultCellModels.value?[indexPath.row]
        } else {
            model = viewModel.defaultCellModels.value?[indexPath.section][indexPath.row]
        }
        
        guard let model else { return UITableViewCell() }
        
        cell.configure(withModel: model)
        
        return cell
    }
}
    //MARK: - TableView delegate methods
    
extension SearchScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let trendingCoinsHeader = PPSectionHeaderView(type: .trendingCoins, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
        
        switch searchBarState {
            
        case .searching:
            let searchingHeader = PPSectionHeaderView(type: .searching, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
            
            return searchingHeader
            
        case .emptyWithoutRecents:
            return [nil, trendingCoinsHeader][section]
            
        case .emptyWithRecents:
            let recentSearchesHeader = PPSectionHeaderView(type: .recentSearches, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
            
            recentSearchesHeader.buttonAction = { [weak self] in
                self?.viewModel.clearRecentSearches()
                UserDefaultsManager.shared.clearRecentSearchesIDs()
            }
            
            return [recentSearchesHeader,trendingCoinsHeader][section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch searchBarState {
        case .emptyWithoutRecents:
            return [0, PPSectionHeaderView.preferredHeight][section]
        case .emptyWithRecents, .searching:
            return PPSectionHeaderView.preferredHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var model: SearchResult?
        
        if isSearching {
            model = viewModel.searchResultCellModels.value?[indexPath.row]
        } else {
            model = viewModel.defaultCellModels.value?[indexPath.section][indexPath.row]
        }
        
        guard let model = model else { return }
       
        searchBar.text = ""
        isSearching = false
        viewModel.clearSearchModels()
        
        UserDefaultsManager.shared.saveToDefaults(
            ID: model.id,
            forKey: DefaultsKeys.recentSearches.rawValue
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
        ResultsCell.preferredHeight
    }
}

    //MARK: - Search bar delegate methods

extension SearchScreenViewController: UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let query = searchBar.text, !query.isEmpty {
            isSearching = true
            noResultsView.isHidden = true
            
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.viewModel.updateSearchResults(query: query)
            }
        } else {
            isSearching = false
            viewModel.clearSearchModels()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let allowedChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: text)
        
        return allowedCharSet.isSuperset(of: typedCharSet)
    }
}
