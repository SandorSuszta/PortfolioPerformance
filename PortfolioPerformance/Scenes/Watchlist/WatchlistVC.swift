import UIKit

class WatchlistViewController: UIViewController {
    
    private let watchlistStore: WatchlistStoreProtocol
    
    private let coordinator: Coordinator
    
    lazy var logo = WatchlistPopUp(superView: view, coinName: "BTC")
    
    private lazy var dataSource: WatchlistDataSource = makeDataSource()
    
    private var watchlistVM = WatchlistViewModel(networkingService: NetworkingService())
    
    private let emptyWatchlistView = EmptyStateView(type: .noFavourites)
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    //MARK: - UI Elements
    
    private lazy var watchlistTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var plusButton: PPRoundedButton = {
        let button = PPRoundedButton(type: .custom)
        button.setImage(UIImage(named: ImageNames.plus), for: .normal)
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var editBarButton = UIBarButtonItem(
        barButtonSystemItem: .edit,
        target: self,
        action: #selector(editButtonPressed)
    )
    
    private lazy var doneBarButton = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(editButtonPressed)
    )
    
    //MARK: - Init
    
    init(coordinator: WatchlistCoordinator, watchlistStore: WatchlistStoreProtocol) {
        self.coordinator = coordinator
        self.watchlistStore = watchlistStore
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureVC()
        configureNavigationController()
        setupTableView()
        setupConstraints()
        bindViewModel()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableWithWatchlist()
        let logo = WatchlistPopUp(superView: view, coinName: "MATIC")
    }
    
    //MARK: - Bind viewModel
    
    private func bindViewModel() {
        watchlistVM.cellViewModels.bind { [weak self] models in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    //MARK: - Private methods
    
    private func configureVC() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureNavigationController() {
        
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Delete BackButton title on pushed screen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    private func setupTableView() {
        
        watchlistTableView.delegate = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .none
        watchlistTableView.layer.cornerRadius = 10
        watchlistTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: view.width / 20))
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        
        watchlistTableView.register(
            CryptoCurrencyCell.self,
            forCellReuseIdentifier: CryptoCurrencyCell.reuseID
        )
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        watchlistTableView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func updateTableWithWatchlist() {
        if watchlistStore.getWatchlist().isEmpty {
            watchlistVM.cellViewModels.value = []
            emptyWatchlistView.isHidden = false
        } else {
            emptyWatchlistView.isHidden = true
            watchlistVM.loadWatchlistDataIfNeeded(
                watchlist: watchlistStore.getWatchlist()
            )
        }
    }
    
    //        watchlistVM.errorMessage?.bind { [weak self] message in
    //            //self?.showAlert(message: message ?? "An error has occured")
    //        }
    
    //MARK: -  Button actions
    
    @objc private func editButtonPressed() {
        watchlistTableView.setEditing(!watchlistTableView.isEditing, animated: true)
        
        navigationItem.rightBarButtonItem = watchlistTableView.isEditing ? doneBarButton : editBarButton
    }
    
    @objc private func plusButtonPressed() {
        if let coordinator = coordinator as? WatchlistCoordinator {
            coordinator.showSearch()
        }
    }
    
    //MARK: - Gestures
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard !watchlistTableView.isEditing else { return }
        
        if gestureRecognizer.state == .began {
            navigationItem.rightBarButtonItem = doneBarButton
            feedbackGenerator.impactOccurred()
            watchlistTableView.setEditing(true, animated: true)
        }
    }
}

//MARK: - TableView DataSource

extension WatchlistViewController {
    
    typealias WatchlistSnapshot = NSDiffableDataSourceSnapshot<WatchlistSection, CoinModel>
    
    private func makeDataSource() -> WatchlistDataSource {
        
        let dataSource = WatchlistDataSource(tableView: watchlistTableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CryptoCurrencyCell.reuseID,
                for: indexPath
            ) as? CryptoCurrencyCell else { return UITableViewCell() }
            
            guard let cellViewModel = self.watchlistVM.cellViewModels.value?[indexPath.row] else { fatalError() }
            
            cell.imageDownloader = ImageDownloader()
            cell.configureCell(with: cellViewModel)
            
            return cell
        }
        
        dataSource.defaultRowAnimation = .fade
        
        dataSource.onMoveCell = { sourceIndexPath, destinationIndexPath in
            
            self.watchlistVM.reorderCellViewModels(from: sourceIndexPath, to: destinationIndexPath)
            self.watchlistStore.reorderWatchlist(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        }
        
        dataSource.onDeleteCell = { indexPath in
            self.watchlistVM.cellViewModels.value?.remove(at: indexPath.row)
        }
        
        return dataSource
    }
    
    private func makeSnapshot() -> WatchlistSnapshot {
        let coinModels = watchlistVM.cellViewModels.value?.map({ $0.coinModel })
        var snapshot = WatchlistSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(coinModels ?? [], toSection: .main)
        return snapshot
    }
    
    private func reloadData() {
        dataSource.apply(makeSnapshot(), animatingDifferences: true)
    }
}

    //MARK: - Setup View Layout

extension WatchlistViewController {
    
    enum Constants {
        static let watchlistWidthToViewWidth: CGFloat = 1 / 2
        
        static let plusButtonRadius: CGFloat = 60
        static let plusButtonPadding: CGFloat = 16
    }
    
    private func configureViewHierarchy() {
        view.addSubviews(
            watchlistTableView,
            emptyWatchlistView,
            plusButton
        )
    }
    
    private func setupConstraints() {
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            watchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            watchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            watchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            watchlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyWatchlistView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyWatchlistView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyWatchlistView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.watchlistWidthToViewWidth),
            emptyWatchlistView.heightAnchor.constraint(equalTo: emptyWatchlistView.widthAnchor),
            
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.plusButtonPadding),
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.plusButtonPadding),
            plusButton.widthAnchor.constraint(equalToConstant: Constants.plusButtonRadius),
            plusButton.heightAnchor.constraint(equalToConstant: Constants.plusButtonRadius)
        ])
    }
}

//MARK: - TableView Delegate
extension WatchlistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CryptoCurrencyCell.prefferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCoinModel = dataSource.itemIdentifier(for: indexPath) else { fatalError("Cant get coinModel in WatclistVC")}
        
        if let coordinator = self.coordinator as? WatchlistCoordinator {
            coordinator.showDetails(for: currentCoinModel)
        }
    }
}

extension WatchlistViewController: TabBarReselectHandler {
    func handleReselect() {
        watchlistTableView.setContentOffset(.zero, animated: true)
    }
}
