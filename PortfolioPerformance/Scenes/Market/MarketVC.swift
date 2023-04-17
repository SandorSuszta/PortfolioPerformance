import UIKit

class MarketViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: MarketViewModel
    private var tableViewSort: PPMarketSort
    
    private var cardsPadding: CGFloat {
        view.width / 16
    }
    
    private var padding: CGFloat {
        view.width / 20
    }
    
    private var cardsWidth: CGFloat {
        (view.width - cardsPadding * 3) / 2
    }
    
    private lazy var marketCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cardsPadding
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 2
        control.pageIndicatorTintColor = .systemBackground
        control.currentPageIndicatorTintColor = .systemGray4
        control.isUserInteractionEnabled = false
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var sortOptionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private let cryptoCurrencyTableView = UITableView()
    
    //MARK: - Init
    init(viewModel: MarketViewModel) {
        self.viewModel = viewModel
        self.tableViewSort = .topCaps
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(viewModel: MarketViewModel())
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
        setupMarketCardsCollectionView()
        setupSortOptionsCollectionView()
        setupTableView()
        addBackgroundToTableView()
    }
    
    //MARK: - Methods
    
    private func setupViewController() {
        view.backgroundColor = .secondarySystemBackground
        
        let imageView = UIImageView(image: UIImage(named: "titleLogo"))
        imageView.contentMode = .scaleAspectFill
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupMarketCardsCollectionView() {
        view.addSubviews(marketCardsCollectionView, pageControl)
        
        marketCardsCollectionView.delegate = self
        marketCardsCollectionView.dataSource = self
        marketCardsCollectionView.backgroundColor = .clear
        marketCardsCollectionView.isPagingEnabled = true
        marketCardsCollectionView.showsHorizontalScrollIndicator = false

        marketCardsCollectionView.register(
            MarketCardMetricCell.self,
            forCellWithReuseIdentifier: MarketCardMetricCell.reuseID
        )
        marketCardsCollectionView.register(
            MarketCardGreedAndFearCell.self,
            forCellWithReuseIdentifier: MarketCardGreedAndFearCell.reuseID
        )
        
        marketCardsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            marketCardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cardsPadding),
            marketCardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -cardsPadding),
            marketCardsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            marketCardsCollectionView.heightAnchor.constraint(equalToConstant:  cardsWidth / 1.2 + 20),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: marketCardsCollectionView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupSortOptionsCollectionView() {
        view.addSubview(sortOptionsCollectionView)
        
        sortOptionsCollectionView.delegate = self
        sortOptionsCollectionView.dataSource = self
        sortOptionsCollectionView.backgroundColor = .clear
        sortOptionsCollectionView.showsHorizontalScrollIndicator = false
        // Set first option as selected
        sortOptionsCollectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )
        sortOptionsCollectionView.register(
            SortOptionsCell.self,
            forCellWithReuseIdentifier: SortOptionsCell.identifier
        )
        sortOptionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortOptionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            sortOptionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            sortOptionsCollectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: -3),
            sortOptionsCollectionView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(cryptoCurrencyTableView)
        
        cryptoCurrencyTableView.delegate = self
        cryptoCurrencyTableView.dataSource = self
        cryptoCurrencyTableView.backgroundColor = .systemBackground
        cryptoCurrencyTableView.separatorStyle = .none
        cryptoCurrencyTableView.layer.cornerRadius = 15
        cryptoCurrencyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        cryptoCurrencyTableView.refreshControl = UIRefreshControl()
        cryptoCurrencyTableView.refreshControl?.tintColor = .PPBlue
        cryptoCurrencyTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        cryptoCurrencyTableView.register(
            CryptoCurrencyCell.self,
            forCellReuseIdentifier: CryptoCurrencyCell.identifier
        )
        
        NSLayoutConstraint.activate([
            cryptoCurrencyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            cryptoCurrencyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            cryptoCurrencyTableView.topAnchor.constraint(equalTo: sortOptionsCollectionView.bottomAnchor, constant: view.height / 150),
            cryptoCurrencyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addBackgroundToTableView() {
        let backGroundView = UIView()
        backGroundView.backgroundColor = .systemBackground
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.layer.cornerRadius = 15
        view.insertSubview(backGroundView, at: 0)
        
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: cryptoCurrencyTableView.topAnchor),
            backGroundView.leftAnchor.constraint(equalTo: cryptoCurrencyTableView.leftAnchor),
            backGroundView.rightAnchor.constraint(equalTo: cryptoCurrencyTableView.rightAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: cryptoCurrencyTableView.bottomAnchor)
        ])
    }
                                                       
    private func bindViewModels() {
        viewModel.cellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.cryptoCurrencyTableView.refreshControl?.endRefreshing()
                self?.cryptoCurrencyTableView.reloadData()
            }
        }
        viewModel.cardViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.marketCardsCollectionView.reloadData()
            }
        }
        viewModel.errorMessage?.bind { [weak self] message in
            self?.showAlert(message: message ?? "An error has occured")
        }
    }
    
    private func scrollToTop() {
        guard
            let models = viewModel.cellViewModels.value,
            !models.isEmpty
        else {
            return
        }
        let topRow = IndexPath(row: 0, section: 0)
        self.cryptoCurrencyTableView.scrollToRow(
            at: topRow,
            at: .top,
            animated: false
        )
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func sortTableview(by sortOption: PPMarketSort) {
        switch sortOption {
        case .topCaps:
            viewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0
            })
        case .topWinners:
            viewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0
            })
        case .topLosers:
            viewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0  < $1.coinModel.priceChangePercentage24H ?? 0
            })
        case .topVolumes:
            viewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.totalVolume ?? 0 > $1.coinModel.totalVolume ?? 0
            })
        }
    }
    
    @objc private func didTapSearch() {
        let searchVC = SearchScreenViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func didPullToRefresh() {
        viewModel.loadAllCryptoCurrenciesData(sortOption: tableViewSort)
    }
    
}

    //MARK: - Collection View methods

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            return viewModel.sortOptionsArray.count
        } else {
            //Market card collection case
            return viewModel.cardViewModels.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            guard let cell = sortOptionsCollectionView.dequeueReusableCell(
                withReuseIdentifier: SortOptionsCell.identifier,
                for: indexPath
            ) as? SortOptionsCell else { return UICollectionViewCell() }
            
            cell.sortingNameLabel.text = viewModel.sortOptionsArray[indexPath.row]
            return cell
        }
        
        
        //Market card collection case
        guard let cellViewModel = viewModel.cardViewModels.value?[indexPath.row] else { fatalError()}
        
        switch cellViewModel.cellType {
        case .bitcoinDominance, .totalMarketCap:
            guard let cell = marketCardsCollectionView.dequeueReusableCell(
                withReuseIdentifier: MarketCardMetricCell.reuseID,
                for: indexPath
            ) as? MarketCardMetricCell else { return UICollectionViewCell() }
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .greedAndFear:
            guard let cell = marketCardsCollectionView.dequeueReusableCell(
                withReuseIdentifier: MarketCardGreedAndFearCell.reuseID,
                for: indexPath
            ) as? MarketCardGreedAndFearCell else { return UICollectionViewCell() }
            
            cell.configure(with: cellViewModel)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == marketCardsCollectionView {
            //Sort options collection case
            return CGSize(
                width: cardsWidth,
                height: cardsWidth / 1.2
            )
        }
        //Sort options collection case
        return CGSize(
            width: collectionView.height * 3.1,
            height: collectionView.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sortOptionsCollectionView {
            switch indexPath.row {
            case 0:
                tableViewSort = .topCaps
            case 1:
                tableViewSort = .topWinners
            case 2:
                tableViewSort = .topLosers
            case 3:
                tableViewSort = .topVolumes
                
            default:
                fatalError()
            }
            
            sortTableview(by: tableViewSort)
            scrollToTop()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == marketCardsCollectionView else { return }
        
        let offset = scrollView.contentOffset.x
        let currentPage = offset == 0 ? 0 : 1
        pageControl.currentPage = currentPage
    }
}

    //MARK: - Table View Delegate and Data Source Methods
    
extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CryptoCurrencyCell.identifier,
            for: indexPath
        ) as? CryptoCurrencyCell else { return UITableViewCell() }
        
        guard let cellViewModel = viewModel.cellViewModels.value?[indexPath.row] else { fatalError() }
        
        cell.imageDownloader = ImageDownloader()
        cell.configureCell(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCoinModel = viewModel.cellViewModels.value?[indexPath.row].coinModel else { fatalError() }
        
        let detailsVC = CoinDetailsVC(
            coinID: currentCoinModel.id,
            coinName: currentCoinModel.name,
            coinSymbol: currentCoinModel.symbol,
            logoURL: currentCoinModel.image,
            isFavourite: UserDefaultsService.shared.isInWatchlist(id: currentCoinModel.id)
        )
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CryptoCurrencyCell.prefferredHeight
    }
}
