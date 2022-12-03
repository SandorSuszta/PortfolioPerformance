import UIKit

enum SectionHeaderType: String {
    case recentSearches = "Recent Searches"
    case trendingCoins = "Trending Coins"
}

class PPSectionHeaderView: UIView {
    
    static let preferredHeight: CGFloat = 40
    
    private let type: SectionHeaderType
    private let nameLabel = UILabel()
    
    var buttonAction: (() -> Void)?
    
    //MARK: - Init
    
    init(type: SectionHeaderType, frame: CGRect, buttonTapHandler: (() -> ())? = nil)
    {
        self.type = type
        super.init(frame: frame)
        setup()
        backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setup() {
        nameLabel.text = type.rawValue
        nameLabel.textAlignment = .left
        nameLabel.textColor = .secondaryLabel
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
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
