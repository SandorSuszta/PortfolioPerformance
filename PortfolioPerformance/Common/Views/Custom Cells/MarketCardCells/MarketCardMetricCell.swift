import UIKit

class MarketCardMetricCell: MarketCardBaseCell {
    
    //MARK: - Properties
    
    static let reuseID = "MarketCardMetricCell"
    
    private let valueLabel = PPTextLabel(fontSize: 22, fontWeight: .semibold)
    
    private let secondaryLabel = PPTextLabel(fontSize: 19, fontWeight: .semibold)
    
    private let progressBar = PPCircularProgressBar(frame: .zero)
    
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

        headerTitle.text = viewModel.cellType.title
        valueLabel.text = viewModel.mainMetricValue
        secondaryLabel.text = viewModel.secondaryMetricValue
        secondaryLabel.textColor = viewModel.secondaryMetricTextColor
        progressBar.progressValue = CGFloat(viewModel.progressValue)
        progressBar.progressColor = viewModel.secondaryMetricTextColor
        self.fadeIn()
    }

    override func configureLayout() {
        super.configureLayout()
        contentView.addSubviews(progressBar, valueLabel, secondaryLabel)
        
        NSLayoutConstraint.activate([
            
            progressBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: width / 12),
            progressBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            valueLabel.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalTo: progressBar.heightAnchor, multiplier: 0.2),
            
            secondaryLabel.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            secondaryLabel.heightAnchor.constraint(equalTo: valueLabel.heightAnchor, multiplier: 0.7),
        ])
    }
}
