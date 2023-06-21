import UIKit

class SortOptionsCell: UICollectionViewCell {
    
    static let identifier = "SortOptionCell"
    static let prefferedHeight: CGFloat = 44
    
    public var sortingNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .PPBlueBackground : .clear
            sortingNameLabel.textColor = isSelected ? .PPBlue : .systemGray
            sortingNameLabel.font = isSelected ? .systemFont(ofSize: 14, weight: .medium) : .systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
