import Charts
import UIKit

class DetailVC: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: CoinDetailsViewModel
    
    private var currentChartTimeInterval = 1
    
    private var isFavourite: Bool
    
    private var favouriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    // Header View and Its Elements
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
        label.text = "0.00"
        label.alpha = 0.0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var priceChangePercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.alpha = 0.0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private var coinLogoShadowView: UIImageView = {
        let view = UIImageView()
        view.configureWithShadow()
        view.backgroundColor = .white
        return view
    }()
    
    private var coinLogoView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    //Chart View
    private var chartView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        return view
    }()
    
    private var lineChartView = LineChartView()
    
    // Interval Selection
    private var timeIntervalSelection = UISegmentedControl()

    // Range ProgressBar
    private var rangeProgressBar: RangeProgressView = {
        let bar = RangeProgressView()
        bar.configureWithShadow()
        bar.titleLabel.text = "Day range"
        bar.progressBar.progress = 0.5
        bar.titleLabel.sizeToFit()
        return bar
    }()
    
    // Details TableView
    private var detailsTableView = UITableView()
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
        view.backgroundColor = .systemGray6
        setUpFavouriteButton()
        bindViewModels()
        viewModel.getMetricsData(coinID: viewModel.coinID)
        setupSegmentedControl()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFavourite = WatchlistManager.shared.isInWatchlist(id: viewModel.coinID)
        updateFavouriteButtonImage()
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
        
        //Graph
        chartView.frame = CGRect(
            x: 20,
            y: coinLogoShadowView.bottom + 20,
            width: view.width - 40,
            height: 200
        )
        
        lineChartView.frame = CGRect(
            x: 5,
            y: 5,
            width: self.chartView.frame.width - 10,
            height: self.chartView.frame.height - 15
        )
     
        timeIntervalSelection.frame = CGRect(
            x: 20,
            y: chartView.bottom + 15,
            width: chartView.width,
            height: 25
        )
        
        //Progress bars
        rangeProgressBar.frame = CGRect(
            x: 20,
            y: timeIntervalSelection.bottom + 15,
            width: chartView.width,
            height: 65
        )
        
        //TableView
        detailsTableView.frame = CGRect(
            x: 20,
            y: rangeProgressBar.bottom + 15,
            width: chartView.width,
            height: 400
        )
        
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: detailsTableView.width,
            height: 40
        )
        
        headerNameLabel.sizeToFit()
        headerNameLabel.frame = CGRect(
            x: 20,
            y: headerView.height/2 - headerNameLabel.height/2,
            width: headerNameLabel.width,
            height: headerNameLabel.height
        )
        
        marketCapRankLabel.sizeToFit()
        marketCapRankLabel.frame = CGRect(
            x: headerView.right - marketCapRankLabel.width - 20,
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
                self?.createGraph(entries: rangeDetails.chartEntries, color: color)
                self?.updatePriceRangeBar(with: rangeDetails)
            }
        }
        
        viewModel.detailsTableViewCelsVM.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.detailsTableView.reloadData()
            }
        }
    }
    
    //MARK: - Init
    
    init(coinID: String, coinName: String, coinSymbol: String, logoURL: String, isFavourite: Bool) {
        viewModel = CoinDetailsViewModel(coinID: coinID)
        self.isFavourite = isFavourite
        super.init(nibName: nil, bundle: nil)
        setupLabelsAndLogo(coinName: coinName, coinSymbol: coinSymbol, logoUrl: logoURL)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    //MARK: - Private methods
    
    private func setupLabelsAndLogo(coinName:String, coinSymbol: String, logoUrl: String) {
        title = coinName
        symbolLabel.text = coinSymbol.uppercased()
        symbolLabel.sizeToFit()
        coinLogoView.setImage(imageData: nil, imageUrl: logoUrl)
    }
    
    private func setUpFavouriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        updateFavouriteButtonImage()
    }
    
    private func updateFavouriteButtonImage() {
        if isFavourite {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            navigationItem.rightBarButtonItem?.tintColor = .black
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
    
    private func createGraph(entries: [ChartDataEntry], color: UIColor) {
        lineChartView.alpha = 1.0
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 1.5
        dataSet.cubicIntensity = 0.5
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        dataSet.highlightLineWidth = 1.5
        dataSet.setColor(color)

        lineChartView.data = LineChartData(dataSet: dataSet)
        lineChartView.data?.setDrawValues(false)
        lineChartView.backgroundColor = .white
        lineChartView.leftAxis.enabled = false // Disable right axis
        lineChartView.xAxis.labelPosition = .bottom // Labels on the bottom
        lineChartView.xAxis.drawGridLinesEnabled = false // Disable vertical grids
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.gridColor = .systemGray6
        lineChartView.legend.enabled = false // Disable legend
        lineChartView.xAxis.setLabelCount(4, force: true) // How many labels on axis
        lineChartView.rightAxis.setLabelCount(4, force: false)
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
       
        //lineChartView.animate(xAxisDuration: 1)
        
        //Gradient
        let gradientColors = [color.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0) // Set gradient
        dataSet.drawFilledEnabled = true // Draw the Gradient
        
        // Disable zooming
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
        // Declare self as the Formatter, conform to AxisValueFormatter
        lineChartView.xAxis.valueFormatter = self
    }
    
    private func setupSegmentedControl() {
        let items = ["1D", "1W", "1M", "6M", "1Y", "MAX"]
        timeIntervalSelection = UISegmentedControl(items: items)
        timeIntervalSelection.selectedSegmentIndex = 0
        timeIntervalSelection.layer.cornerRadius = 5
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
        
        if isFavourite {
            WatchlistManager.shared.deleteFromWatchlist(ID: viewModel.coinID)
        } else {
            WatchlistManager.shared.saveToWatchlist(ID: viewModel.coinID)
        }
        isFavourite = !isFavourite
        updateFavouriteButtonImage()
    }
    
    private func setupTableView() {
        DispatchQueue.main.async {
            self.detailsTableView.dataSource = self
            self.detailsTableView.delegate = self
            self.detailsTableView.tableHeaderView = self.headerView
            self.detailsTableView.configureWithShadow()
            self.detailsTableView.clipsToBounds = false
            self.detailsTableView.layer.masksToBounds = false
            self.detailsTableView.separatorStyle = .singleLine
            self.detailsTableView.separatorColor = .systemGray5
            self.detailsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.detailsTableView.isScrollEnabled = false
            self.detailsTableView.register(
                DetailsTableViewCell.self,
                forCellReuseIdentifier: DetailsTableViewCell.identifier
            )
        }
    }
}

    //MARK: - TableView delegate and data source

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    
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
        DetailsTableViewCell.prefferedHeight
    }
}

    //MARK: - Charts delegate

extension DetailVC: AxisValueFormatter, ChartViewDelegate {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value/1000)
        return .stringForGraphAxis(from: date, daysInterval: currentChartTimeInterval)
    }
}
