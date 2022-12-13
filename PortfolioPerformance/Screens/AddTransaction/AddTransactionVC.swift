import UIKit

class AddTransactionVC: UIViewController {
    
    //MARK: - Properties
    
    private let searchBar = CustomSearchBar(frame: .zero)
    
    lazy private var resultsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.configureWithShadow()
        return collection
    }()
      
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setUpSearchBar()
        setupCollectionView()
        setupConstraints()
    }
    
    //MARK: - Private methods
    
    private func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delete(self)
    }
    
    private func setupCollectionView() {
        view.addSubview(resultsCollectionView)
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        resultsCollectionView.register(AddTransactionCell.self, forCellWithReuseIdentifier: AddTransactionCell.identifier)
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            resultsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            resultsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension AddTransactionVC: UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: string)
        
        if allowedCharSet.isSuperset(of: typedCharSet) {
            
            
            return true
        } else {
            return false
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let query = searchBar.text, !query.isEmpty {
//            isSearching = true
//            noResultsView.isHidden = true
//
//            searchTimer?.invalidate()
//            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
//                self.viewModel.updateSearchResults(query: query)
        } else {
//            isSearching = false
//            viewModel.clearSearchModels()
        }
    }
}
    //MARK: - Collection View Delegate And DataSource

extension AddTransactionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTransactionCell.identifier, for: indexPath) as! AddTransactionCell
        cell.configure(with: SearchResult(id: "BTC", name: "BTC", symbol: "BTC", large: ""))
        return cell
    }
}
