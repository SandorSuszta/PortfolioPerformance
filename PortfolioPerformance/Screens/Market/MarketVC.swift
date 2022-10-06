import UIKit

class MarketViewController: UIViewController {
    
    //MARK: - Properties
    
    private let marketVM = MarketViewModel()
    
    private var marketCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private var sortOptionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private let cryptoCurrencyTableView = UITableView()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        bindViewModels()
        marketVM.loadGreedAndFearIndex()
        marketVM.loadGlobalData()
        marketVM.loadAllCryptoCurrenciesData()
        addSearchButton()
        setupMarketCardsCollectionView()
        setupSortOptionsCollectionView()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    //MARK: - Methods
    
    //Setup VC
    private func setupViewController() {
        view.backgroundColor = .systemGray6
        
        //Set Title Logo
        let imageView = UIImageView(image: UIImage(named: "titleLogo"))
        imageView.contentMode = .scaleAspectFill
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //Market Cards Setup
    private func setupMarketCardsCollectionView() {
        view.addSubview(marketCardsCollectionView)
        
        marketCardsCollectionView.delegate = self
        marketCardsCollectionView.dataSource = self
        marketCardsCollectionView.backgroundColor = .clear
        marketCardsCollectionView.showsHorizontalScrollIndicator = false
        marketCardsCollectionView.register(
            MarketCardsCollectionViewCell.self,
            forCellWithReuseIdentifier: MarketCardsCollectionViewCell.identifier
        )
        marketCardsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            marketCardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            marketCardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            marketCardsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            marketCardsCollectionView.heightAnchor.constraint(equalToConstant: 156)
        ])
    }
    
    //Sort Options Setup
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
            SortOptionsCollectionViewCell.self,
            forCellWithReuseIdentifier: SortOptionsCollectionViewCell.identifier
        )
        sortOptionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortOptionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortOptionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortOptionsCollectionView.topAnchor.constraint(equalTo: marketCardsCollectionView.bottomAnchor),
            sortOptionsCollectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //Table View Setup
    private func setupTableView() {
        view.addSubview(cryptoCurrencyTableView)
        
        cryptoCurrencyTableView.delegate = self
        cryptoCurrencyTableView.dataSource = self
        cryptoCurrencyTableView.backgroundColor = .systemGray6
        cryptoCurrencyTableView.separatorStyle = .none
        cryptoCurrencyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        cryptoCurrencyTableView.register(
            CryptoCurrenciesTableViewCell.self,
            forCellReuseIdentifier: CryptoCurrenciesTableViewCell.identifier
        )
        
        NSLayoutConstraint.activate([
            cryptoCurrencyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            cryptoCurrencyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cryptoCurrencyTableView.topAnchor.constraint(equalTo: sortOptionsCollectionView.bottomAnchor, constant: 3),
            cryptoCurrencyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        }
        
        //Market card collection case
        return marketVM.cardViewModels.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            guard let cell = sortOptionsCollectionView.dequeueReusableCell(
                withReuseIdentifier: SortOptionsCollectionViewCell.identifier,
                for: indexPath
            ) as? SortOptionsCollectionViewCell else { return UICollectionViewCell() }
            
            cell.sortingNameLabel.text = marketVM.sortOptionsArray[indexPath.row]
            return cell
        }
        
        //Market card collection case
        guard let cell = marketCardsCollectionView.dequeueReusableCell(
            withReuseIdentifier: MarketCardsCollectionViewCell.identifier,
            for: indexPath
        ) as? MarketCardsCollectionViewCell else { return UICollectionViewCell() }
        
        guard let cellViewModel = marketVM.cardViewModels.value?[indexPath.row] else { fatalError()}
        cell.configureCard(with: cellViewModel)
        cell.configureWithShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == marketCardsCollectionView {
            //Sort options collection case
            return CGSize(
                width: MarketCardsCollectionViewCell.preferredWidth,
                height: MarketCardsCollectionViewCell.preferredHeight
            )
        }
        //Sort options collection case
        return CGSize(
            width: SortOptionsCollectionViewCell.preferredWidth,
            height: SortOptionsCollectionViewCell.preferredHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            sortTableview(byOption: indexPath.row)
            scrollToTop()
        }
    }
    
    //Distance between the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    //Left inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}
    //MARK: - Table View Delegate and Data Source Methods
    
extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        marketVM.cellViewModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CryptoCurrenciesTableViewCell.identifier,
            for: indexPath
        ) as? CryptoCurrenciesTableViewCell else { return UITableViewCell() }
        
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
            isFavourite: WatchlistManager.shared.isInWatchlist(id: currentCoinModel.id)
        )
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CryptoCurrenciesTableViewCell.prefferedHeight
    }
}
