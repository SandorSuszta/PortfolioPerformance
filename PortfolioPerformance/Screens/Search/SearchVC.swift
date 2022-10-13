import UIKit

class SearchScreenViewController: UIViewController {

    private var viewModel = SearchScreenViewModel()
    
    private var searchTimer: Timer?
    
    private let sectionHeaderHeight: CGFloat = 40
    
    private var isSearching: Bool = false
    
    lazy var searchBar = UISearchBar()
    
    private let resultsTableView: UITableView = {
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
    }
    
    private func bindViewModels() {
        
        viewModel.searchResultCellModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
            }
        }
        
        viewModel.emptySearchCellModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard let message = message else { return }
            
            self?.showAlert(message: message)
        }
    }
    
    private func createSectionHeader(withName name: String, addClearButton: Bool = false) -> UIView {
        
        let header = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: sectionHeaderHeight
        ))
        header.backgroundColor = .systemGray5
        
        let label = UILabel(frame: CGRect(
            x: 20,
            y: 0,
            width: header.width - 20,
            height: header.height
        ))
        label.text = name
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        
        
        header.addSubview(label)
        
        return header
    }
}

    //MARK: - TableView delegate methods

extension SearchScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        isSearching ? 1 : viewModel.emptySearchCellModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        isSearching ? viewModel.searchResultCellModels.value?.count ?? 0 : viewModel.emptySearchCellModels.value?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            return nil
        } else {
            return createSectionHeader(withName: "Trending coins")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        isSearching ? 0 : sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = resultsTableView.dequeueReusableCell(
            withIdentifier: ResultsTableViewCell.identifier,
            for: indexPath
        ) as? ResultsTableViewCell else { return UITableViewCell() }
        
        if let searchResults = viewModel.searchResultCellModels.value {
            
            cell.configure(with: searchResults[indexPath.row])
            
        } else {
            
            guard let model = viewModel.emptySearchCellModels.value?[indexPath.section][indexPath.row] else { return UITableViewCell() }
            
            cell.configure(with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var model: SearchResult?
        
        if let searchResults = viewModel.searchResultCellModels.value {
            model = searchResults[indexPath.row]
        } else {
            model = viewModel.emptySearchCellModels.value?[indexPath.section][indexPath.row]
        }
        
        guard let model = model else { return }
        
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
        ResultsTableViewCell.preferedHeight
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
    
