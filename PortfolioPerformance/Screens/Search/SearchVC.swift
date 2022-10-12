import UIKit

class SearchScreenViewController: UIViewController {

    var viewModel = SearchScreenViewModel()
    
    var searchResultsArray: [SearchResult] = []
    
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
        
        viewModel.searchTableCellModels.bind { _ in
            DispatchQueue.main.async {
                self.resultsTableView.reloadData()
            }
        }

        setUpResultsTableVIew()
        setUpTitleView()
        setUpSearchController()
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchResultsArray.isEmpty {
           return viewModel.searchTableCellModels.value?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResultsArray.isEmpty {
            return viewModel.searchTableCellModels.value?[section].count ?? 0
        } else {
            return searchResultsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = resultsTableView.dequeueReusableCell(
            withIdentifier: ResultsTableViewCell.identifier,
            for: indexPath
        ) as? ResultsTableViewCell else { return UITableViewCell() }
        
        if searchResultsArray.isEmpty {
            guard let model = viewModel.searchTableCellModels.value?[indexPath.section][indexPath.row] else { return cell }
            
            cell.configure(with: model)
        } else {
            cell.configure(with: searchResultsArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var model: SearchResult?
        
        if searchResultsArray.isEmpty {
            model = viewModel.searchTableCellModels.value?[indexPath.section][indexPath.row]
        } else {
            model = searchResultsArray[indexPath.row]
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
extension SearchScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //Check if not empty
        if let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        {
//            searchTimer?.invalidate()
//            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
//                self.performSearch(query: query)
            performSearch(query: query)

        } else {
            clearTableView()
        }
    }
    
    func clearTableView() {
        searchResultsArray = []
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
        }
    }
    
    func performSearch(query: String) {
        NetworkingManager.shared.searchWith(
            query: query) { result in
                switch result {
                case.success(let response):
                    self.searchResultsArray = response.coins
                    DispatchQueue.main.async {
                        self.resultsTableView.reloadData()
                    }
                case .failure(let error):
                    self.showAlert(message: error.rawValue)
                }
            }
    }
}
    
