import UIKit

class SearchScreenViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?

    //MARK: - Properties

    private let coordinator: Coordinator
    
    private lazy var dataSource = SearchTableDataSource(tableView: resultsTableView)
    
    private let viewModel: SearchScreenViewModel
    
    private var searchTimer: Timer?
    
    private var isSearching: Bool = false
    
    private var searchBarState: SearchBarState {
        determineSearchBarState(
            isSearching: isSearching,
            isRecentSearchesEmpty: viewModel.isRecentSearchesEmpty
        )
    }
    
    //MARK: - UI Elements
    
    lazy private var searchBar = UISearchBar()
    
    private let resultsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.sectionHeaderTopPadding = 0
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.separatorColor = .secondarySystemBackground
        table.separatorInset = .zero
        table.register(
            ResultsCell.self,
            forCellReuseIdentifier: ResultsCell.identifier
        )
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let noResultsView = EmptyStateView(type: .noSearchResults)
    
    //MARK: - Init
    
    init(coordinator: Coordinator, viewModel: SearchScreenViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    convenience init(coordinator: Coordinator) {
        self.init(coordinator: coordinator, viewModel: SearchScreenViewModel(networkingService: NetworkingService()))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        viewModel.updateRecentSearches()
    }
    
    //MARK: - Private
    
    private func setUpViewController() {
      
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(noResultsView)
        
        //Delete BackButton title on pushed screen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.largeTitleDisplayMode = .never
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
    }
    
    private func bindViewModels() {
        
        viewModel.searchResultCellModels.bind { [weak self] _ in
            guard let self else { return }
      
            DispatchQueue.main.async {
                self.reloadData()
                
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
                self.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard
                let self = self,
                let message = message
            else {
                return
            }
            
            self.coordinator.navigationController.showAlert(message: message)
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
            return .searching(resultModels: viewModel.searchResultCellModels.value ?? [])
            
        case (false, false):
            return .emptyWithRecents(recentModels: viewModel.defaultCellModels.value?[0] ?? [],
                                     trendingModels: viewModel.defaultCellModels.value?[1] ?? [])
        case (false, true):
            return .emptyWithoutRecents(trendingModels: viewModel.defaultCellModels.value?[1] ?? [])
        }
    }
}

    //MARK: - TableView data source methods

extension SearchScreenViewController {
    
    typealias SearchScreenSnapshot = NSDiffableDataSourceSnapshot<SearchTableViewSection, SearchResult>
    
    private func makeSnapshot() -> SearchScreenSnapshot {
        var snapshot = SearchScreenSnapshot()
        
        switch searchBarState {
            
        case .emptyWithRecents(let recentModels, let trendingModels):
            snapshot.appendSections([.recentSearches, .trendingCoins])
            snapshot.appendItems(recentModels, toSection: .recentSearches)
            snapshot.appendItems(trendingModels, toSection: .trendingCoins)
            
        case .emptyWithoutRecents(let trendingModels):
            snapshot.appendSections([.trendingCoins])
            snapshot.appendItems(trendingModels, toSection: .trendingCoins)
            
        case .searching(let resultModels):
            snapshot.appendSections([.searchResults])
            snapshot.appendItems(resultModels, toSection: .searchResults)
        }
        
        return snapshot
    }
    
    func reloadData() {
        dataSource.apply(makeSnapshot(), animatingDifferences: true)
    }
}

    //MARK: - TableView delegate methods
    
extension SearchScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionIdentifiers = dataSource.snapshot().sectionIdentifiers
        guard sectionIdentifiers.indices.contains(section) else { return nil }
        let sectionIdentifier = sectionIdentifiers[section]
        
        switch sectionIdentifier {
            
        case .searchResults:
            return nil
            
        case .recentSearches:
            let recentSearchesHeader = PPSectionHeaderView(type: .recentSearches, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
            
            recentSearchesHeader.buttonAction = { [weak self] in
                self?.viewModel.clearRecentSearches()
                UserDefaultsService.shared.clearRecentSearchesIDs()
            }
            return recentSearchesHeader
            
        case .trendingCoins:
            let trendingCoinsHeader = PPSectionHeaderView(type: .trendingCoins, frame: CGRect(x: 0, y: 0, width: view.width, height: PPSectionHeaderView.preferredHeight))
            return trendingCoinsHeader
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        PPSectionHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let model = dataSource.itemIdentifier(for: indexPath) else { fatalError("Cant get coinModel in Search VC") }
        
        searchBar.text = ""
        isSearching = false
        viewModel.clearSearchModels()
        
        UserDefaultsService.shared.saveTo(
            .recentSearches,
            ID: model.id
        )
        
        delegate?.handleSelection(of: model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ResultsCell.preferredHeight
    }
}
    //MARK: - Search bar delegate methods

extension SearchScreenViewController: UISearchBarDelegate  {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
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
