import Charts
import UIKit

class CoinDetailsVC: UIViewController {
    
    //MARK: - Properties
    
    private let coordinator: Coordinator
    private let viewModel: CoinDetailsViewModel
    private let imageDownloader: ImageDownloaderProtocol
    private let watchlistStore: WatchlistStoreProtocol
    
    private var currentChartTimeInterval = 1
    
    private var padding: CGFloat {
        view.width / 20
    }
    
    private var favouriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .regular)
        return label
    }()
    
    private var priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var priceChangePercentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var coinLogoShadowView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var coinLogoView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private var chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var lineChartView = LineChartView()

    private var timeIntervalSelection = UISegmentedControl()

    private var rangeProgressBar: RangeProgressView = {
        let bar = RangeProgressView()
        bar.titleLabel.text = "Day range"
        bar.progressBar.progress = 0.5
        bar.titleLabel.sizeToFit()
        return bar
    }()
    
    private var detailsTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var headerView = UIView()
    
    private var headerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private var marketCapRankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setUpFavouriteButton()
        bindViewModels()
        setupSegmentedControl()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavouriteButtonImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Prevent strong reference cycle
        lineChartView.xAxis.valueFormatter = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(scrollView)
        scrollView.addSubviews(symbolLabel, priceLabel, priceChangeLabel, priceChangePercentageLabel, coinLogoShadowView, chartView, timeIntervalSelection, rangeProgressBar, detailsTableView)
        
        coinLogoShadowView.addSubview(coinLogoView)
        chartView.addSubview(lineChartView)
        headerView.addSubviews(headerNameLabel, marketCapRankLabel)
        
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.width, height: 1000)
        
        symbolLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: symbolLabel.height
        )
        
        coinLogoShadowView.frame = CGRect(
            x: view.right - 120,
            y: symbolLabel.bottom + 20,
            width: 85,
            height: 85
        )
        
        coinLogoView.frame = CGRect(
            x: 10,
            y: 10,
            width: coinLogoShadowView.width - 20,
            height: coinLogoShadowView.height - 20
        )
        
        priceLabel.frame = CGRect(
            x: 35,
            y: coinLogoShadowView.top + 15,
            width: priceLabel.width,
            height: priceLabel.height
        )
        
        priceChangeLabel.frame = CGRect(
            x: priceLabel.left,
            y: priceLabel.bottom + 5,
            width: priceChangeLabel.width,
            height: priceChangeLabel.height
        )
        
        priceChangePercentageLabel.frame = CGRect(
            x: priceChangeLabel.right + 5,
            y: priceLabel.bottom + 5,
            width: priceChangePercentageLabel.width,
            height: priceChangePercentageLabel.height
        )
        
        chartView.frame = CGRect(
            x: padding,
            y: coinLogoShadowView.bottom + 20,
            width: view.width - 2 * padding,
            height: 220
        )
        
        lineChartView.frame = CGRect(
            x: 5,
            y: 5,
            width: chartView.width - 10,
            height: chartView.height - 15
        )
     
        timeIntervalSelection.frame = CGRect(
            x: padding,
            y: chartView.bottom + 10,
            width: chartView.width,
            height: 25
        )
        
        rangeProgressBar.frame = CGRect(
            x: padding,
            y: timeIntervalSelection.bottom + 10,
            width: chartView.width,
            height: 65
        )
        
        detailsTableView.frame = CGRect(
            x: 0,
            y: rangeProgressBar.bottom + 10,
            width: view.width,
            height: 370
        )
        
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: detailsTableView.width,
            height: 40
        )
        
        headerNameLabel.sizeToFit()
        headerNameLabel.frame = CGRect(
            x: 30,
            y: headerView.height/2 - headerNameLabel.height/2,
            width: headerNameLabel.width,
            height: headerNameLabel.height
        )
        
        marketCapRankLabel.sizeToFit()
        marketCapRankLabel.frame = CGRect(
            x: headerView.right - marketCapRankLabel.width - 30,
            y: headerNameLabel.top,
            width: marketCapRankLabel.width,
            height: marketCapRankLabel.height
        )
    }
    
    //MARK: - Bind View Models

    private func bindViewModels() {
        
        viewModel.metricsVM.bind { [weak self] _ in
            guard let metrics = self?.viewModel.metricsVM.value else { return }
            
            DispatchQueue.main.async {
                self?.updateCurrentPrice(with: metrics.currentPrice)
                self?.marketCapRankLabel.text = self?.viewModel.metricsVM.value?.marketCapRank
            }
            
            self?.viewModel.createDetailsCellsViewModels()
            self?.viewModel.getTimeRangeDetails(
                coinID: self?.viewModel.coinID ?? "",
                intervalInDays: self?.currentChartTimeInterval ?? 1
            )
        }
        
        viewModel.rangeDetailsVM.bind { [weak self] _ in
            
            guard let rangeDetails = self?.viewModel.rangeDetailsVM.value else { return }
            
            let color: UIColor = rangeDetails.isChangePositive ? .nephritis : .pinkGlamour
            
            DispatchQueue.main.async {
                self?.updateRangeLabels(with: rangeDetails)
                self?.lineChartView.createNewChart(entries: rangeDetails.chartEntries, color: color)
                self?.updatePriceRangeBar(with: rangeDetails)
            }
        }
        
        viewModel.detailsTableViewCelsVM.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.detailsTableView.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard let message = message else { return }
            
            self?.coordinator.showAlert(message: message)
        }
    }
    
    //MARK: - Init
    
    init(
        coordinator: Coordinator,
        viewModel: CoinDetailsViewModel,
        imageDownloader: ImageDownloaderProtocol,
        watchlistStore: WatchlistStoreProtocol
    ){
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.imageDownloader = imageDownloader
        self.watchlistStore = watchlistStore
        
        super.init(nibName: nil, bundle: nil)
        
        setupLabelsAndLogo(with: viewModel.representedCoin)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    //MARK: - Private methods
    
    private func setupVC() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.largeTitleDisplayMode = .never
        lineChartView.xAxis.valueFormatter = self
    }
    
    private func setupLabelsAndLogo(with representedCoin: CoinRepresenatable ) {
        title = representedCoin.name
        symbolLabel.text = representedCoin.symbol.uppercased()
        symbolLabel.sizeToFit()
        
        imageDownloader.loadImage(from: representedCoin.image) { [weak self] result in
            
            switch result {
            case .success(let (_ , image)):
                self?.coinLogoView.image = image
            case .failure(let error):
                //TODO: Handle properly
                print(error)
            }
        }
    }
    
    private func setUpFavouriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        updateFavouriteButtonImage()
    }
    
    private func updateFavouriteButtonImage() {
        if viewModel.isFavourite {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            navigationItem.rightBarButtonItem?.tintColor = .favouriteButtonColor
        }
    }
    
    private func updateCurrentPrice(with price: String) {
        priceLabel.text = price
        priceLabel.sizeToFit()
    }
    
    private func updatePriceRangeBar(with rangeData: RangeDetailsViewModel) {
        
        rangeProgressBar.rightTopLabel.text = rangeData.rangeHigh
        rangeProgressBar.rightTopLabel.sizeToFit()
        
        rangeProgressBar.rightBottomLabel.text = rangeData.percentageFromHigh
        rangeProgressBar.rightBottomLabel.sizeToFit()
        
        rangeProgressBar.leftTopLabel.text = rangeData.rangeLow
        rangeProgressBar.leftTopLabel.sizeToFit()
        
        rangeProgressBar.leftBottomLabel.text = rangeData.percentageFromLow
        rangeProgressBar.leftBottomLabel.sizeToFit()
        
        rangeProgressBar.progressBar.setProgress(rangeData.progress, animated: true)
    }
    
    private func updateRangeLabels(with rangeDetails: RangeDetailsViewModel) {
        priceChangeLabel.text = rangeDetails.priceChange
        priceChangeLabel.sizeToFit()
        priceChangeLabel.alpha = 1.0
        priceChangePercentageLabel.text = "(" + rangeDetails.priceChangePercentage + ")"
        priceChangePercentageLabel.sizeToFit()
        priceChangePercentageLabel.alpha = 1.0
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        if rangeDetails.isChangePositive  {
            priceChangeLabel.textColor = .nephritis
            priceChangePercentageLabel.textColor = .nephritis
        } else {
            priceChangeLabel.textColor = .pomergranate
            priceChangePercentageLabel.textColor = .pomergranate
        }
    }
    
    private func setupSegmentedControl() {
        timeIntervalSelection = CustomSegmentedControl(
            items: viewModel.chartIntervals,
            defaultColor: .PPBlue
        )
        timeIntervalSelection.addTarget(self, action: #selector(didChangeSegment(_:)) , for: .valueChanged)
    }
    
    @objc func didChangeSegment(_ sender: UISegmentedControl) -> Void {
        var rangeName = ""
        lineChartView.fadeOut()
        priceChangeLabel.fadeOut()
        priceChangePercentageLabel.fadeOut()
        switch sender.selectedSegmentIndex {
        case 0:
            currentChartTimeInterval = 1
            rangeName = "Day range"
        case 1:
            currentChartTimeInterval = 7
            rangeName = "Week Range"
        case 2:
            currentChartTimeInterval = 30
            rangeName = "Month range"
        case 3:
            currentChartTimeInterval = 180
            rangeName = "Six month range"
        case 4:
            currentChartTimeInterval = 360
            rangeName = "Year range"
        case 5:
            currentChartTimeInterval = 2000
            rangeName = "All time range"
        default:
            fatalError("Invalid segment selection")
        }
        
        rangeProgressBar.titleLabel.text = rangeName
        rangeProgressBar.titleLabel.sizeToFit()
        
        viewModel.getTimeRangeDetails(coinID: viewModel.coinID, intervalInDays: currentChartTimeInterval)
    }
    
    @objc func favouriteButtonTapped() {

        if viewModel.isFavourite {
            UserDefaultsService.shared.deleteFrom(
                .watchlist,
                ID: viewModel.coinID
            )
        } else {
            UserDefaultsService.shared.saveTo(
                .watchlist,
                ID: viewModel.coinID
            )
        }
        
        updateFavouriteButtonImage()
    }
    
    private func setupTableView() {
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.tableHeaderView = self.headerView
        detailsTableView.clipsToBounds = false
        detailsTableView.layer.masksToBounds = false
        detailsTableView.separatorStyle = .singleLine
        detailsTableView.separatorColor = .systemGray5
        detailsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        detailsTableView.isScrollEnabled = false
        detailsTableView.register(
            DetailsCell.self,
            forCellReuseIdentifier: DetailsCell.identifier
        )
    }
}

    //MARK: - TableView delegate and data source

extension CoinDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.detailsTableViewCelsVM.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DetailsCell.identifier,
            for: indexPath
        ) as? DetailsCell else { return UITableViewCell() }
        
        guard let viewModel = viewModel.detailsTableViewCelsVM.value?[indexPath.row] else { fatalError() }
                
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DetailsCell.preferredHeight
    }
}

    //MARK: - Charts delegate

extension CoinDetailsVC: AxisValueFormatter, ChartViewDelegate {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value/1000)
        return .stringForGraphAxis(from: date, daysInterval: currentChartTimeInterval)
    }
}
