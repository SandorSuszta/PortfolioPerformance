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
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            contentView.layer.borderColor = isSelected ? UIColor.timeIntervalSelectionBorderColor.cgColor : UIColor.clear.cgColor
        }
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
            sortingNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            sortingNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sortingNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            sortingNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
