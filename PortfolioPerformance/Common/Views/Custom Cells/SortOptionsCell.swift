import UIKit

class SortOptionsCell: UICollectionViewCell {
    
    static let reuseID = "SortOptionCell"
    static let prefferedHeight: CGFloat = 44
    
    //MARK: - UI Elements
    
    private let sortingNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 0.8 : 0
            contentView.layer.borderColor = isSelected ? UIColor.timeIntervalSelectionBorderColor.cgColor : UIColor.clear.cgColor
            contentView.backgroundColor = isSelected ? .timeIntervalSelectionBackground : .clear
            sortingNameLabel.textColor = isSelected ? .timeIntervalSelectionTextColor : .systemGray
            sortingNameLabel.font = isSelected ? .systemFont(ofSize: 14, weight: .medium) : .systemFont(ofSize: 14, weight: .regular)
            
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    func setTitle(_ title: String) {
        sortingNameLabel.text = title
    }
    
    //MARK: - Private methods
    
    private func configureContentView() {
        contentView.layer.cornerRadius = contentView.height / 5
        
        contentView.addSubview(sortingNameLabel)
        NSLayoutConstraint.activate([
            sortingNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sortingNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortingNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            sortingNameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor)
        ])
    }
}
