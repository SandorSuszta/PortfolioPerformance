import UIKit

final class DetailsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "DetailsTableViewCell"
    static let preferredHeight: CGFloat = 40
    
    public var metricName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    public var metricValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(metricName, metricValue)
        contentView.backgroundColor = .tertiarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        metricName.sizeToFit()
        metricValue.sizeToFit()
        
        metricName.frame = CGRect(
            x: 20,
            y: contentView.height/2 - metricName.height/2,
            width: metricName.width,
            height: metricName.height
        )
        
        metricValue.frame = CGRect(
            x: contentView.right - metricValue.width - 20,
            y: contentView.height/2 - metricName.height/2,
            width: metricValue.width,
            height: metricValue.height
        )
    }
    
    //MARK: - Public methods
    
    public func configure(with viewModel: DetailsCellsViewModel) {
        metricName.text = viewModel.name
        metricValue.text = viewModel.value
        selectionStyle = .none
    }
}

