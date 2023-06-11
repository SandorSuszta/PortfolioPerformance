import UIKit
  
/// Delegate protocol for handling button tap events in the `PPSectionHeaderView`.
protocol SearchTableSectionHeaderDelegate: AnyObject {
    func didTapButton()
}

final class SearchTableSectionHeader: UIView {
    
    static let preferredHeight: CGFloat = 40
    
    weak var delegate: SearchTableSectionHeaderDelegate?
    
    private let title: String
    
    private let buttonTitle: String?

    private let shouldDisplayButton: Bool
    
    //MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonTitleFontSize, weight: .regular)
        button.titleLabel?.textAlignment = .right
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    init(withTitle title: String, shouldDisplayButton: Bool, buttonTitle: String? = nil, frame: CGRect) {
        self.shouldDisplayButton = shouldDisplayButton
        self.title = title
        self.buttonTitle = buttonTitle
        super.init(frame: frame)
        configure()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func configure() {
        backgroundColor = .clear
        titleLabel.text = self.title
    }
    
    @objc private func didTapButton() {
        delegate?.didTapButton()
    }
}

    //MARK: - Layou Views

private extension SearchTableSectionHeader {
    enum Constants {
        static let titleFontSize: CGFloat = 16
        static let buttonTitleFontSize: CGFloat = 14
        static let actionButtonTrailingPadding: CGFloat = 16
    }
    
    func layoutViews() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        if shouldDisplayButton {
            addButton(withTitle: self.buttonTitle ?? "")
        }
    }
    
    func addButton(withTitle title: String) {
       
        addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.actionButtonTrailingPadding)
        ])
    }
}
