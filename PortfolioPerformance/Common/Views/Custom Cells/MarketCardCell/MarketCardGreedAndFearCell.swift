import UIKit

class MarketCardGreedAndFearCell: MarketCardBaseCell {
    
    //MARK: - Properties
    
    static let reuseID = "MarketCardGreedAndFearCell"
    
    private let valueLabel = PPTextLabel(fontSize: 22, fontWeight: .semibold)
    
    private let descriptonLabel = PPTextLabel(fontSize: 18, fontWeight: .semibold)
    
    private let progressBar = PPSegmentedProgressBar(frame: .zero)
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.alpha = 0
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    public func configure(with viewModel: MarketCardCellViewModel) {
        headerTitle.text = viewModel.cellType.cellTitle
        valueLabel.text = viewModel.mainMetricValue
        descriptonLabel.text = viewModel.secondaryMetricValue
        descriptonLabel.textColor = viewModel.secondaryMetricTextColor
        progressBar.setProgress(CGFloat(viewModel.progressValue))
        
        self.fadeIn()
    }
    
    override func configureLayout() {
        super.configureLayout()
        contentView.addSubviews(progressBar, valueLabel, descriptonLabel)
        
        NSLayoutConstraint.activate([
            descriptonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptonLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: -(height / 8)),
            descriptonLabel.heightAnchor.constraint(equalTo: headerTitle.heightAnchor),
            
            progressBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: width / 12),
            progressBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            valueLabel.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalTo: progressBar.heightAnchor, multiplier: 0.215)
        ])
    }
}

