import UIKit
//TODO: - Implement pull to refresh

class MarketViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let coordinator: Coordinator
    private let viewModel: MarketViewModel

    //MARK: - UI Elements
    
    private lazy var marketCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: MarketCompositionalLayout()
        )
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        //TODO: - register CryptoCurrencyCells
        return collection
    }()
    
    //MARK: - Init
    
    init(coordinator: Coordinator, viewModel: MarketViewModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        bindViewModels()
        addSearchButton()
        setupMarketCollectionViewLayout()
    }
                            
    //MARK: - Bind view models
    
    private func bindViewModels() {
        viewModel.cellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadMarketData()
            }
        }
        viewModel.cardViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadMarketData()
            }
        }
        
//        viewModel.errorMessage?.bind { [weak self] message in
//            //self?.showAlert(message: message ?? "An error has occured")
//        }
    }

    //MARK: - Private methods
    
    private func reloadMarketData() {
        
    }
    
    private func setupNavigationController() {
        addSearchButton()
        addTitleLogoView()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    private func addTitleLogoView() {
        let imageView = UIImageView(image: UIImage(named: "titleLogo"))
        imageView.contentMode = .scaleAspectFill
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
    }
    
//    private func sortTableview(by sortOption: PPMarketSort) {
//        viewModel.sortCellViewModels(by: sortOption)
//    }
    
    private func setupViewController() {
        view.backgroundColor = .secondarySystemBackground
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupMarketCollectionViewLayout() {
        view.addSubviews(marketCollectionView)
        marketCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            marketCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            marketCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            marketCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            marketCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    //MARK: - Selectors
    
    @objc private func didTapSearch() {
        if let coordinator = coordinator as? MarketCoordinator {
            coordinator.showSearch()
        }
    }
}

    //MARK: - CollectionView Delegate methods

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}
