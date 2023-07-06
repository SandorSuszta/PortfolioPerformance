import Charts
import UIKit

class CoinDetailsVC: UIViewController {
    
    //MARK: - Dependecies
    
    private let coordinator: Coordinator
    private let viewModel: CoinDetailsViewModel
    private let imageDownloader: ImageDownloaderProtocol
    private let watchlistStore: WatchlistStoreProtocol
    
    //MARK: - Properties
    
    private var currentChartTimeInterval: TimeRangeInterval = .day
    
    //MARK: - UI Elements
    
    private var favouriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let highlightsView = HighlightsView()
    
    private var chartContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.addShadow()
        return view
    }()
    
    private lazy var lineChartView = PPLineChartView()

    private lazy var timeIntervalSelection: PPSegmentedControl = {
        let segmentControl = PPSegmentedControl(
            items: viewModel.rangeIntervals.map { $0.segmentName },
            backgroundColor: .PPBlue
        )
        segmentControl.addTarget(self, action: #selector(didSelectRangeInterval) , for: .valueChanged)
        return segmentControl
    }()

    private var rangeProgressBar: RangeProgressView = {
        let bar = RangeProgressView()
        bar.addShadow()
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
        setupHierarchy()
        initialUISetup(for: viewModel.representedCoin)
        setupVC()
        setUpFavouriteButton()
        bindViewModels()
        setupTableView()
        layoutViews()
        setChartAxisLabelsFormatter(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavouriteButtonImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Prevent strong reference cycle when VC is popped
        if self.isMovingFromParent {
            setChartAxisLabelsFormatter(nil)
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        scrollView.frame = view.bounds
//        scrollView.contentSize = CGSize(width: view.width, height: 1000)
//
//        timeIntervalSelection.frame = CGRect(
//            x: padding,
//            y: ChartContainerView.bottom + 10,
//            width: ChartContainerView.width,
//            height: 25
//        )
//
//        rangeProgressBar.frame = CGRect(
//            x: padding,
//            y: timeIntervalSelection.bottom + 10,
//            width: ChartContainerView.width,
//            height: 65
//        )
//
//        detailsTableView.frame = CGRect(
//            x: 0,
//            y: rangeProgressBar.bottom + 10,
//            width: view.width,
//            height: 370
//        )
//
//        headerView.frame = CGRect(
//            x: 0,
//            y: 0,
//            width: detailsTableView.width,
//            height: 40
//        )
//
//        headerNameLabel.sizeToFit()
//        headerNameLabel.frame = CGRect(
//            x: 30,
//            y: headerView.height/2 - headerNameLabel.height/2,
//            width: headerNameLabel.width,
//            height: headerNameLabel.height
//        )
//
//        marketCapRankLabel.sizeToFit()
//        marketCapRankLabel.frame = CGRect(
//            x: headerView.right - marketCapRankLabel.width - 30,
//            y: headerNameLabel.top,
//            width: marketCapRankLabel.width,
//            height: marketCapRankLabel.height
//        )
//    }
    
    //MARK: - Bind View Models

    private func bindViewModels() {
        
        viewModel.metricsVM.bind { [weak self] _ in
            guard let metrics = self?.viewModel.metricsVM.value else { return }
            
            DispatchQueue.main.async {
                self?.highlightsView.setCurrentPrice(metrics.currentPrice)
                self?.marketCapRankLabel.text = self?.viewModel.metricsVM.value?.marketCapRank
            }
            
            self?.viewModel.createDetailsCellsViewModels()
            self?.viewModel.getTimeRangeDetails(
                coinID: self?.viewModel.coinID ?? "",
                intervalInDays: self?.currentChartTimeInterval.numberOfDays ?? 1
            )
        }
        
        viewModel.rangeDetailsVM.bind { [weak self] _ in
            
            guard let self = self,
                  let rangeDetails = self.viewModel.rangeDetailsVM.value
            else { return }
            
            let color: UIColor = rangeDetails.isChangePositive ? .nephritis : .pinkGlamour
            
            DispatchQueue.main.async {
                self.updateRangeLabels(with: rangeDetails)
                self.lineChartView.setChartData(rangeDetails.chartEntries)
                self.lineChartView.setChartColor(color)
                
                //self?.lineChartView.createNewChart(entries: rangeDetails.chartEntries, color: color)
                //self?.updatePriceRangeBar(with: rangeDetails)
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    //MARK: - Private methods
    
    private func setupVC() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    /// Sets the formatter to be used for formatting the axis labels on the chart
    private func setChartAxisLabelsFormatter(_ formatter: AxisValueFormatter?) {
        lineChartView.xAxis.valueFormatter = formatter
    }
    
    private func initialUISetup(for coin: CoinRepresenatable) {
        self.title = coin.name
        highlightsView.setSymbolName(coin.symbol.uppercased())
        setLogo(fromURL: coin.image)
    }

    private func setLogo(fromURL url: String) {
        imageDownloader.loadImage(from: url) { [weak self] result in
            
            switch result {
            case .success(let (_ , image)):
                self?.highlightsView.setLogo(image)
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
    
    
    private func updateRangeLabels(with rangeDetails: RangeDetailsViewModel) {
        highlightsView.setPriceChangeLabels(
            priceChange: rangeDetails.priceChange,
            inPercentage: rangeDetails.priceChangePercentage,
            color: rangeDetails.isChangePositive ? .nephritis : .pomergranate
        )
    }
    
    private func updateUIForSelectedTimeInterval(_ selectedTimeInterval: TimeRangeInterval) {
        
        rangeProgressBar.setTitle(selectedTimeInterval.rangeName)
        
        viewModel.getTimeRangeDetails(
            coinID: viewModel.coinID,
            intervalInDays: selectedTimeInterval.numberOfDays
        )
    }
    
    @objc func didSelectRangeInterval(_ sender: UISegmentedControl) -> Void {
        let interval = viewModel.rangeIntervals[sender.selectedSegmentIndex]
        currentChartTimeInterval = interval
        updateUIForSelectedTimeInterval(interval)
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
       
        return .stringForGraphAxis(
            from: date,
            rangeInterval: currentChartTimeInterval
        )
    }
}

    // MARK: - Setup Views

extension CoinDetailsVC {
    
    enum Constants {
        static let standartPadding: CGFloat = 8
        static let largePadding: CGFloat = 16
        
        static let segmentedControlHeight: CGFloat = 28
        static let chartViewHeight: CGFloat = 232
    }
    private func setupHierarchy() {
        view.addSubviews(highlightsView, chartContainerView, lineChartView, timeIntervalSelection)
        //scrollView.addSubviews(ChartContainerView, timeIntervalSelection, rangeProgressBar, detailsTableView)
        //headerView.addSubviews(headerNameLabel, marketCapRankLabel)
    }
    
    private func layoutViews() {
        highlightsView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        timeIntervalSelection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            highlightsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            highlightsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            highlightsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            highlightsView.heightAnchor.constraint(equalToConstant: HighlightsView.prefferedHeight),
            
            chartContainerView.topAnchor.constraint(equalTo: highlightsView.bottomAnchor),
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartContainerView.heightAnchor.constraint(equalToConstant: Constants.chartViewHeight),
            
            lineChartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: Constants.standartPadding),
            lineChartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: Constants.standartPadding),
            lineChartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -Constants.standartPadding),
            lineChartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -Constants.standartPadding),
            
            timeIntervalSelection.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: Constants.largePadding),
            timeIntervalSelection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.largePadding),
            timeIntervalSelection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.largePadding),
            timeIntervalSelection.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight),
        ])
    }
}
