import UIKit
//TODO: - Dependency Injection: Consider using dependency injection to inject the SearchScreenViewModel instead of instantiating it directly in the view controller. This can make the code more testable and easier to maintain.

enum SectionHeaderType: String {
    case recentSearches = "Recent Searches"
    case trendingCoins = "Trending Coins"
}

class PPSectionHeaderView: UIView {
    
    static let preferredHeight: CGFloat = 40
    
    private let type: SectionHeaderType
    
    lazy var nameLabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 10
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        label.layer.masksToBounds = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedString = NSAttributedString(string: type.rawValue, attributes: attributes)
        label.attributedText = attributedString
        return label
    }()
    
    var buttonAction: (() -> Void)?
    
    //MARK: - Init
    
    init(type: SectionHeaderType, frame: CGRect, buttonTapHandler: (() -> ())? = nil) {
        self.type = type
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        if type == .recentSearches {
            addClearButton()
        }
    }
    
    private func addClearButton() {
        let button = UIButton(frame: .zero)
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.titleLabel?.textAlignment = .right
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    @objc private func buttonTapped() {
        guard let buttonAction else { return }
        buttonAction()
    }
}
