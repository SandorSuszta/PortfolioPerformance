import UIKit

class AddTransactionVC: UIViewController {
    
    //MARK: - Properties
    
    private let searchBar = CustomSearchBar(frame: .zero)
    
    private let viewModel = AddTransactionViewModel()
    
    private var searchTimer: Timer?
    
    private let noSearchResultsView = EmptyStateView(type: .noSearchResults)
    
    private lazy var resultsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.configureWithShadow()
        return collection
    }()
    
    public var state: SearchState = .defaultCells {
        didSet {
            switch state {
            case .defaultCells, .searchResult:
                DispatchQueue.main.async {
                    self.noSearchResultsView.isHidden = true
                }
            case .nothingFound:
                DispatchQueue.main.async {
                    self.noSearchResultsView.isHidden = false
                }
            }
            
            self.applySnapshot()
        }
    }
    
    enum SearchState {
        case searchResult
        case nothingFound
        case defaultCells
    }
    
    private lazy var dataSource = createDataSource()
    
    enum Section {
        case main
    }
      
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpSearchBar()
        setupCollectionView()
        bindViewModels()
        setupConstraints()
    }
    
    //MARK: - Private methods
    
    private func setUpViewController() {
        view.backgroundColor = .secondarySystemBackground
        title = "Add new transaction"
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(10, for: .default)
    }
    
    private func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.delegate = self
    }
    
    private func setupCollectionView() {
        view.addSubviews(resultsCollectionView, noSearchResultsView)
        resultsCollectionView.register(AddTransactionCell.self, forCellWithReuseIdentifier: AddTransactionCell.identifier)
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, SearchResult> {
        let dataSource = UICollectionViewDiffableDataSource<Section, SearchResult>(
            collectionView: resultsCollectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
                
                guard let cell = self.resultsCollectionView.dequeueReusableCell(withReuseIdentifier: AddTransactionCell.identifier, for: indexPath) as? AddTransactionCell else { return UICollectionViewCell() }
                
                let model: SearchResult?
                
                switch self.state {
                case .defaultCells:
                    model = self.viewModel.defaultModels.value?[indexPath.row]
                case .searchResult, .nothingFound:
                    model = self.viewModel.searchResultCellModels.value?[indexPath.row]
                }
                
                cell.configure(with: model)
                return cell
            }
        return dataSource
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>()
        snapshot.appendSections([.main])
        switch state {
        case .defaultCells:
            snapshot.appendItems(viewModel.defaultModels.value ?? [])
        case .searchResult, .nothingFound:
            snapshot.appendItems(viewModel.searchResultCellModels.value ?? [])
        }
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 20
        let minimumInterimSpacing: CGFloat = 10
        let availableWidth = view.bounds.width - 40 - minimumInterimSpacing * 3 - padding * 2
        let cellWidth = availableWidth / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 25)
        layout.minimumInteritemSpacing = minimumInterimSpacing
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return layout
    }
    
    private func bindViewModels() {
        
        viewModel.searchResultCellModels.bind { [weak self] _ in
            
            guard
                let self = self,
                let models = self.viewModel.searchResultCellModels.value
            else {
                return
            }
            
            self.state = models.isEmpty ? .nothingFound : .searchResult
        }
        
        viewModel.defaultModels.bind { [weak self] _ in
            self?.state = .defaultCells
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
        let collectionViewHeight: CGFloat = (((view.bounds.width - 110) / 4) + 25) * 2 + 50
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            resultsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            resultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
    
            noSearchResultsView.centerXAnchor.constraint(equalTo: resultsCollectionView.centerXAnchor),
            noSearchResultsView.topAnchor.constraint(equalTo: resultsCollectionView.topAnchor, constant: 50),
            noSearchResultsView.heightAnchor.constraint(equalTo: resultsCollectionView.heightAnchor, constant: -100),
            noSearchResultsView.widthAnchor.constraint(equalTo: noSearchResultsView.heightAnchor)
        ])
    }
}

extension AddTransactionVC: UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: string)
        
        guard allowedCharSet.isSuperset(of: typedCharSet) else { return false }
        
        searchTimer?.invalidate()
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newString.isEmpty {
            self.viewModel.getDefaultModels()
        } else {
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.viewModel.getSearchResults(query: newString)
            }
        }
        
        return true
    }
}
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let query = searchBar.text, !query.isEmpty {
////            isSearching = true
////            noResultsView.isHidden = true
////
////            searchTimer?.invalidate()
////            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
////                self.viewModel.updateSearchResults(query: query)
//        } else {
////            isSearching = false
////            viewModel.clearSearchModels()
//        }
//    }

    //MARK: - Collection View Delegate And DataSource

//extension AddTransactionVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        viewModel.searchResultCellModels.value?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTransactionCell.identifier, for: indexPath) as? AddTransactionCell,
//            let model = viewModel.searchResultCellModels.value?[indexPath.row]
//        else {
//            return UICollectionViewCell()
//        }
//
//        cell.configure(with: model)
//        return cell
//    }
//}
