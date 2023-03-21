import UIKit

class MarketViewController: UIViewController {
    
    //MARK: - Properties
    
    private let marketVM = MarketViewModel()
    
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

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        bindViewModels()
        addSearchButton()
        setupMarketCardsCollectionView()
        setupSortOptionsCollectionView()
        setupTableView()
        addBackGroundViewForTbaleView()
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
            sortOptionsCollectionView.heightAnchor.constraint(equalToConstant: view.height / 30)
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
    
    private func addBackGroundViewForTbaleView() {
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
        marketVM.cellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.cryptoCurrencyTableView.reloadData()
            }
        }
        marketVM.cardViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.marketCardsCollectionView.reloadData()
            }
        }
        marketVM.errorMessage?.bind { [weak self] message in
            self?.showAlert(message: message ?? "An error has occured")
        }
    }
    
    private func scrollToTop() {
        guard
            let models = marketVM.cellViewModels.value,
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
    }
    
    private func sortTableview(byOption number: Int) {
        switch number {
        case 0: //Top Market Cap
            marketVM.cellViewModels.value?.sort(by: {
                $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0
            })
        case 1: //Top Winners
            marketVM.cellViewModels.value?.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0
            })
        case 2: //Top Losers
            marketVM.cellViewModels.value?.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0  < $1.coinModel.priceChangePercentage24H ?? 0
            })
        case 3: //Top Volume
            marketVM.cellViewModels.value?.sort(by: {
                $0.coinModel.totalVolume ?? 0 > $1.coinModel.totalVolume ?? 0
            })
        default:
            fatalError()
        }
    }
    
    @objc private func searchTapped() {
        let searchVC = SearchScreenViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

    //MARK: - Collection View methods

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            return marketVM.sortOptionsArray.count
        } else {
            //Market card collection case
            return marketVM.cardViewModels.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            guard let cell = sortOptionsCollectionView.dequeueReusableCell(
                withReuseIdentifier: SortOptionsCell.identifier,
                for: indexPath
            ) as? SortOptionsCell else { return UICollectionViewCell() }
            
            cell.sortingNameLabel.text = marketVM.sortOptionsArray[indexPath.row]
            return cell
        }
        
        
        //Market card collection case
        guard let cellViewModel = marketVM.cardViewModels.value?[indexPath.row] else { fatalError()}
        
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
            
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.cryptoCurrencyTableView.alpha = 0
            }
            sortTableview(byOption: indexPath.row)
            cryptoCurrencyTableView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.cryptoCurrencyTableView.alpha = 1
            }
            
            scrollToTop()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let currentPage = offset == 0 ? 0 : 1
        pageControl.currentPage = currentPage
    }
}

    //MARK: - Table View Delegate and Data Source Methods
    
extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        marketVM.cellViewModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CryptoCurrencyCell.identifier,
            for: indexPath
        ) as? CryptoCurrencyCell else { return UITableViewCell() }
        
        guard let cellViewModel = marketVM.cellViewModels.value?[indexPath.row] else { fatalError() }
        
        cell.configureCell(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCoinModel = marketVM.cellViewModels.value?[indexPath.row].coinModel else { fatalError() }
        
        let detailsVC = CoinDetailsVC(
            coinID: currentCoinModel.id,
            coinName: currentCoinModel.name,
            coinSymbol: currentCoinModel.symbol,
            logoURL: currentCoinModel.image,
            isFavourite: UserDefaultsManager.shared.isInWatchlist(id: currentCoinModel.id)
        )
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.height / 15
    }
}
