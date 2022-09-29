import UIKit

class RangeProgressView: UIView {
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    public var leftTopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    public var leftBottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .nephritis
        return label
    }()
    public var rightTopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    public var rightBottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .pomergranate
        return label
    }()
    public var progressBar: CustomProgressView = {
        let progress = CustomProgressView()
        progress.customHeight = 10
        progress.trackTintColor
        = .pinkGlamour
        progress.progressTintColor = .emerald
        progress.layer.cornerRadius = 6
        progress.clipsToBounds = true
        return progress
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
}
