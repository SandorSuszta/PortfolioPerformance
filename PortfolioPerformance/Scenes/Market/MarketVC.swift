import UIKit
//TODO: - Implement pull to refresh

class MarketViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let coordinator: Coordinator
    private let viewModel: MarketViewModel
    
    private lazy var dataSource = MarketDataSource(
        collectionView: marketCollectionView,
        sortHeaderDelegate: self
    )

    //MARK: - UI Elements
    
    private lazy var marketCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: MarketCompositionalLayout()
        )
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
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
        setupNavigationController()
        bindViewModels()
        registerCellsAndHeader()
        setupMarketCollectionViewLayout()
    }
                            
    //MARK: - Bind view models
    
    private func bindViewModels() {
        viewModel.marketCards.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadMarketData()
            }
        }
        viewModel.cryptoCoinsViewModelsState.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.reloadMarketData()
            }
        }
        
//        viewModel.errorMessage?.bind { [weak self] message in
//            //self?.showAlert(message: message ?? "An error has occured")
//        }
    }

    //MARK: - Private methods
    
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
    
    private func registerCellsAndHeader() {
        marketCollectionView.register(
            MarketCardMetricCell.self,
            forCellWithReuseIdentifier: MarketCardMetricCell.reuseID
        )
        marketCollectionView.register(
            MarketCardGreedAndFearCell.self,
            forCellWithReuseIdentifier: MarketCardGreedAndFearCell.reuseID
        )
        marketCollectionView.register(
            CryptoCurrencyCollectionViewCell.self,
            forCellWithReuseIdentifier: CryptoCurrencyCollectionViewCell.reuseID
        )
        marketCollectionView.register(SortSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SortSectionHeader.reuseID)
    }
    
    private func setupMarketCollectionViewLayout() {
        view.addSubviews(marketCollectionView)
        marketCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            marketCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            marketCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

    //MARK: - TableView data source methods

extension MarketViewController {
    
    typealias MarketSnapshot = NSDiffableDataSourceSnapshot<MarketSection, MarketItem>
    
    private func makeSnapshot() -> MarketSnapshot {
        var snapshot = MarketSnapshot()
        
        snapshot.appendSections([.global, .coins])
        
        viewModel.marketCards.value.forEach { card in
            switch card {
            case .loading:
                snapshot.appendItems([MarketItem.marketCard(.loading(id: UUID()))], toSection: .global)
            case .dataReceived(let viewModel):
                snapshot.appendItems([MarketItem.marketCard(.dataReceived(viewModel))], toSection: .global)
            }
        }
        
        switch viewModel.cryptoCoinsViewModelsState.value {
        case .loading:
            let loadingCells = (0...10).map { MarketItem.cryptoCoinCell(.loading(index: $0))}
            snapshot.appendItems(loadingCells, toSection: .coins)
        case .dataReceived(let viewModels):
            let cryptoCoinCells = viewModels.map { MarketItem.cryptoCoinCell(.dataReceived($0))}
            snapshot.appendItems(cryptoCoinCells, toSection: .coins)
        }
        
        return snapshot
    }
    
    private func reloadMarketData() {
        dataSource.apply(makeSnapshot(), animatingDifferences: false)
    }
}

    //MARK: - CollectionView delegate methods

extension MarketViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let coordinator = coordinator as? MarketCoordinator,
              let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        
        if case .cryptoCoinCell(.dataReceived(let viewModel) ) = item {
            coordinator.showDetails(for: viewModel.coinModel)
        }
    }
}

    //MARK: - SortSectionHeader delegate method
    
extension MarketViewController: SortSectionHeaderDelegate {
    
    func didSelectSortOption(_ sortOption: MarketSortOption) {
        viewModel.sortCellViewModels(by: sortOption)
        
        if isCryptoCurrencySectionOutOfViewBounds() {
            marketCollectionView.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
        }
    }
    
    private func isCryptoCurrencySectionOutOfViewBounds() -> Bool {
        guard let sectionFrame = marketCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 1))?.frame else { return false }
        
        return sectionFrame.origin.y < marketCollectionView.contentOffset.y
    }
}

    //MARK: -  TabBarReselectHandler method

extension MarketViewController: TabBarReselectHandler {
    func handleReselect() {
        marketCollectionView.setContentOffset(.zero, animated: true)
    }
}
