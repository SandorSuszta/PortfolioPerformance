import UIKit

class RangeProgressView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Day range"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let leftTopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let leftBottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .nephritis
        return label
    }()
    
    private let rightTopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let rightBottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .pomergranate
        return label
    }()
    
    private let progressBar: CustomProgressView = {
        let bar = CustomProgressView()
        bar.customHeight = 16
        bar.progress = 0.5
        bar.trackTintColor = .priceRangeRed
        bar.progressTintColor = .priceRangeGreen
        bar.layer.cornerRadius = 8
        bar.clipsToBounds = true
        return bar
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 15
        addSubviews(titleLabel, leftTopLabel, leftBottomLabel, rightTopLabel, rightBottomLabel, progressBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeLabels()
        
        titleLabel.frame = CGRect(
            x: width/2 - titleLabel.width/2,
            y: 5,
            width: titleLabel.width,
            height: titleLabel.height
        )
        
        progressBar.frame = CGRect(
            x: 20,
            y: titleLabel.bottom + 10,
            width: width - 40,
            height: progressBar.height
        )
        
        rightTopLabel.frame = CGRect(
            x: progressBar.right - rightTopLabel.width,
            y: progressBar.top - rightTopLabel.height - 2,
            width: rightTopLabel.width,
            height: rightTopLabel.height
        )
        
        rightBottomLabel.frame = CGRect(
            x: progressBar.right - rightBottomLabel.width,
            y: progressBar.bottom + 2,
            width: rightBottomLabel.width,
            height: rightBottomLabel.height
        )
        
        leftTopLabel.frame = CGRect(
            x: progressBar.left,
            y: progressBar.top - leftTopLabel.height - 2,
            width: leftTopLabel.width,
            height: leftTopLabel.height
        )
        
        leftBottomLabel.frame = CGRect(
            x: progressBar.left,
            y: progressBar.bottom + 2,
            width: leftBottomLabel.width,
            height: leftBottomLabel.height
        )
    }
    
    //MARK: - Private methods
    
    private func resizeLabels() {
        titleLabel.sizeToFit()
        leftTopLabel.sizeToFit()
        leftBottomLabel.sizeToFit()
        rightTopLabel.sizeToFit()
        rightBottomLabel.sizeToFit()
    }
    
    // MARK: - API
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func configure(with viewModel: RangeDetailsViewModel) {
        rightTopLabel.text = viewModel.rangeHigh
        rightBottomLabel.text = viewModel.percentageFromHigh
        leftTopLabel.text = viewModel.rangeLow
        leftBottomLabel.text = viewModel.percentageFromLow
        
        progressBar.setProgress(viewModel.progress, animated: true)
    }
}
