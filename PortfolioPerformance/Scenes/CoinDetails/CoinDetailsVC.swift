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
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.contentSize = CGSize(width: view.width, height: 892)
        return scroll
    }()
    
    
    private let highlightsView = HighlightsView()
    
    private var chartContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.applyShadow()
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    
    private lazy var lineChartView = PPLineChartView()
    
    private lazy var chartLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .PPBlue
        return indicator
    }()

    private lazy var timeIntervalSelection: PPSegmentedControl = {
        let segmentControl = PPSegmentedControl(
            items: viewModel.rangeIntervals.map { $0.segmentName },
            backgroundColor: .PPBlue
        )
        segmentControl.addTarget(self, action: #selector(didSelectRangeInterval) , for: .valueChanged)
        return segmentControl
    }()

    private var rangeProgressView: RangeProgressView = {
        let bar = RangeProgressView()
        bar.applyShadow()
        bar.backgroundColor = .tertiarySystemBackground
        return bar
    }()
    
    private lazy var detailsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.clipsToBounds = false
        table.layer.masksToBounds = false
        table.separatorStyle = .none
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        table.register(
            DetailsTableViewCell.self,
            forCellReuseIdentifier: DetailsTableViewCell.identifier
        )
        return table
    }()
    
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
        showLoadingIndicator(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavouriteButtonImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Prevent strong reference cycle, set nil only when popped
        if self.isMovingFromParent {
            setChartAxisLabelsFormatter(nil)
        }
    }
        
        // Handle shadow colors are not updated automatically when theme is changed
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateShadowsColor()
        }
    }

    //MARK: - Bind View Models

    private func bindViewModels() {
        
        viewModel.metricsVM.bind { [weak self] _ in
            guard let metrics = self?.viewModel.metricsVM.value else { return }
            
            DispatchQueue.main.async {
                self?.highlightsView.setCurrentPrice(metrics.currentPrice)
                self?.marketCapRankLabel.text = self?.viewModel.metricsVM.value?.marketCapRank
            }
            
            self?.viewModel.makeDetailsCellsViewModels()
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
                self.showLoadingIndicator(false)
                self.updateRangeLabels(with: rangeDetails)
                self.rangeProgressView.configure(with: rangeDetails)
                
                self.lineChartView.setChartData(rangeDetails.chartEntries)
                self.lineChartView.setChartColor(color)
                
                self.lineChartView.fadeIn()
                self.highlightsView.fadeInChangeLabels()
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
    
    private func showLoadingIndicator(_ show: Bool) {
        if show {
            chartLoadingIndicator.startAnimating()
            lineChartView.isHidden = true
        } else {
            chartLoadingIndicator.stopAnimating()
            lineChartView.isHidden = false
        }
    }
    
    private func updateUIForSelectedTimeInterval(_ selectedTimeInterval: TimeRangeInterval) {
        
        rangeProgressView.setTitle(selectedTimeInterval.rangeName)
        
        viewModel.getTimeRangeDetails(
            coinID: viewModel.coinID,
            intervalInDays: selectedTimeInterval.numberOfDays
        )
    }
    
    /// Sets the formatter to be used for formatting the axis labels on the chart
    private func setChartAxisLabelsFormatter(_ formatter: AxisValueFormatter?) {
        lineChartView.xAxis.valueFormatter = formatter
    }
    
    private func updateShadowsColor() {
        chartContainerView.applyShadow()
        rangeProgressView.applyShadow()
        highlightsView.applyShadowToLogoContainer()
    }
    
    // MARK: - Selectors
    
    @objc func didSelectRangeInterval(_ sender: UISegmentedControl) -> Void {
        let interval = viewModel.rangeIntervals[sender.selectedSegmentIndex]
        currentChartTimeInterval = interval
        updateUIForSelectedTimeInterval(interval)
        lineChartView.fadeOut()
        highlightsView.fadeOutChangeLabels()
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
        detailsTableView.clipsToBounds = false
        detailsTableView.layer.masksToBounds = false
        detailsTableView.separatorStyle = .singleLine
        detailsTableView.separatorColor = .systemGray5
        detailsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        detailsTableView.isScrollEnabled = false
        detailsTableView.register(
            DetailsTableViewCell.self,
            forCellReuseIdentifier: DetailsTableViewCell.identifier
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
            withIdentifier: DetailsTableViewCell.identifier,
            for: indexPath
        ) as? DetailsTableViewCell else { return UITableViewCell() }
        
        guard let viewModel = viewModel.detailsTableViewCelsVM.value?[indexPath.row] else { fatalError() }
                
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DetailsTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DetailsTableViewHeader()
        header.setMarketCapRank(viewModel.marketCapRank)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        DetailsTableViewHeader.prefferedHeight
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
        static let smallPadding: CGFloat = 8
        static let padding: CGFloat = 12
        static let largePadding: CGFloat = 20
        
        static let segmentedControlHeight: CGFloat = 28
        static let chartViewHeight: CGFloat = 232
        static let rangeProgressViewHeight: CGFloat = 70
    }
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubviews(highlightsView, chartContainerView, lineChartView, chartLoadingIndicator, timeIntervalSelection, rangeProgressView, detailsTableView)
    }
    
    private func layoutViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        highlightsView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        timeIntervalSelection.translatesAutoresizingMaskIntoConstraints = false
        chartLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        rangeProgressView.translatesAutoresizingMaskIntoConstraints = false
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            highlightsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            highlightsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            highlightsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            highlightsView.heightAnchor.constraint(equalToConstant: HighlightsView.prefferedHeight),
            
            chartContainerView.topAnchor.constraint(equalTo: highlightsView.bottomAnchor),
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartContainerView.heightAnchor.constraint(equalToConstant: Constants.chartViewHeight),
            
            lineChartView.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: Constants.smallPadding),
            lineChartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: Constants.smallPadding),
            lineChartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -Constants.smallPadding),
            lineChartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -Constants.smallPadding),
            
            chartLoadingIndicator.centerXAnchor.constraint(equalTo: chartContainerView.centerXAnchor),
            chartLoadingIndicator.centerYAnchor.constraint(equalTo: chartContainerView.centerYAnchor),
            
            timeIntervalSelection.topAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: Constants.padding),
            timeIntervalSelection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.largePadding),
            timeIntervalSelection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.largePadding),
            timeIntervalSelection.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight),
            
            rangeProgressView.topAnchor.constraint(equalTo: timeIntervalSelection.bottomAnchor, constant: Constants.padding),
            rangeProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.largePadding),
            rangeProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.largePadding),
            rangeProgressView.heightAnchor.constraint(equalToConstant: Constants.rangeProgressViewHeight),
            
            detailsTableView.topAnchor.constraint(equalTo: rangeProgressView.bottomAnchor, constant: Constants.smallPadding),
            detailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsTableView.heightAnchor.constraint(equalToConstant: 8 * DetailsTableViewCell.preferredHeight + DetailsTableViewHeader.prefferedHeight)
        ])
    }
}
