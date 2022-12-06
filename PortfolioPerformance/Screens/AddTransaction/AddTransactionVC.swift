import UIKit

class AddTransactionVC: UIViewController {
    
    //MARK: - Private
    
    let searchBar = CustomSearchBar(frame: .zero)
    // Add search bar
    // add collectionView
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSearchBar()
        setupConstraints()
    }
    
    private func setUpSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //set delegate
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}

extension AddTransactionVC: UISearchBarDelegate  {
    
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
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let allowedChars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: text)
        
        return allowedCharSet.isSuperset(of: typedCharSet)
    }
}
