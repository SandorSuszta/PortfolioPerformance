import UIKit

class WatchlistViewController: UIViewController {
    
    private let coordinator: Coordinator
    
    private var viewModel: WatchlistViewModel
    
    private lazy var dataSource: WatchlistDataSource = makeDataSource()
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private var selectedSortOption: WatchlistSortOption
    
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
    
    private let emptyWatchlistView = EmptyStateView(type: .noFavourites)
    
    //MARK: - Init
    
    init(coordinator: WatchlistCoordinator, viewModel: WatchlistViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.selectedSortOption = .custom
        super .init(nibName: nil, bundle: nil)
    }
    
    convenience init(coordinator: WatchlistCoordinator) {
        self.init(coordinator: coordinator, viewModel: WatchlistViewModel())
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
        updateTableWithCurrentWatchlist()
    }
    
    //MARK: - Bind viewModel
    
    private func bindViewModel() {
        viewModel.cellViewModels.bind { [weak self] models in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] error in
            guard let self = self else { return }
            
            switch error {
            case .noErrors:
                break
            case .error(let error):
                self.coordinator.navigationController.showAlert(
                    message: error.rawValue,
                    retryHandler: self
                )
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
        navigationItem.leftBarButtonItem = makeSortButton()
    }
    
    private func setupTableView() {
        
        watchlistTableView.delegate = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .none
        watchlistTableView.layer.cornerRadius = 10
        watchlistTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: view.width / 20))
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        watchlistTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 60))
        watchlistTableView.register(
            CryptoCurrencyCell.self,
            forCellReuseIdentifier: CryptoCurrencyCell.reuseID
        )
    }
    
    private func updateTableWithCurrentWatchlist() {
        if viewModel.isWatchlistEmpty {
            viewModel.cellViewModels.value = []
            emptyWatchlistView.isHidden = false
        } else {
            emptyWatchlistView.isHidden = true
            viewModel.loadWatchlistData(forSortOption: selectedSortOption)
        }
    }
    
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
}

    // MARK: - Sort UIMenu

extension WatchlistViewController {
    
    private func makeSortButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: "\(selectedSortOption.name) \(Constants.arrowDown)",
            menu: makeSortMenu(currentWatchlist: viewModel.watchlist)
        )
    }
    
    private func makeSortMenu(currentWatchlist: [String]) -> UIMenu {
        UIMenu(children: [
            makeActionForOption(.custom),
            makeActionForOption(.alphabetical),
            makeActionForOption(.topMarketCap),
            makeActionForOption(.topWinners),
            makeActionForOption(.topLosers)
        ])
    }
    
    private func makeActionForOption(_ option: WatchlistSortOption) -> UIAction {
        
        UIAction(title: option.name, image: option.logo) { _ in
            self.navigationItem.leftBarButtonItem?.title = "\(option.name) \(Constants.arrowDown)"
            self.viewModel.sortCellViewModels(by: option)
            self.selectedSortOption = option
            
            self.dataSource.canMoveCells = option == .custom ? true : false
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
            
            let cellViewModel = self.viewModel.cellViewModels.value[indexPath.row]
            
            cell.imageDownloader = ImageDownloader()
            cell.configureCell(with: cellViewModel)
            
            return cell
        }
        
        dataSource.defaultRowAnimation = .fade
        
        dataSource.onMoveCell = { sourceIndexPath, destinationIndexPath in
            
            self.viewModel.reorderCellViewModels(from: sourceIndexPath, to: destinationIndexPath)
            self.viewModel.reorderWatchlist(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        }
        
        dataSource.onDeleteCell = { indexPath in
            self.viewModel.cellViewModels.value.remove(at: indexPath.row)
        }
        
        return dataSource
    }
    
    private func makeSnapshot() -> WatchlistSnapshot {
        let coinModels = viewModel.cellViewModels.value.map({ $0.coinModel })
        var snapshot = WatchlistSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(coinModels, toSection: .main)
        return snapshot
    }
    
    private func reloadData() {
        dataSource.apply(makeSnapshot(), animatingDifferences: true)
    }
}

    //MARK: - Setup View Layout

extension WatchlistViewController {
    
    enum Constants {
        static let arrowDown = "\u{25BE}"
        static let customSortButtonName = "Custom"
        
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

extension  WatchlistViewController: ErrorAlertDelegate {
    func didPressRetry() {
        viewModel.resetError()
        viewModel.loadWatchlistData(forSortOption: selectedSortOption)
    }
}
