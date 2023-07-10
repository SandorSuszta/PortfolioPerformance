import UIKit

final class WatchlistPopUp {
    
    private let coinName : String
    
    private let bottomConstraint: NSLayoutConstraint
    
    //MARK: - UI Elements
    
    private weak var superView: UIView?
    
    private let view: UIView = {
        let view  = UIView()
        view.layer.cornerRadius = Constants.viewCornerRadius
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.popUpBorder.cgColor
        view.backgroundColor = .popUpBackground
        return view
    }()
    
    private let checkmarkLogo = UIImageView(image: UIImage(named: Constants.imageName))
    
    private let titleLabel: PPTextLabel = {
        let label = PPTextLabel(textColor: .gray.withAlphaComponent(0.8))
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Init
    
    init(superView: UIView, coinName: String) {
        self.superView = superView
        self.coinName = coinName
        bottomConstraint = view.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: Constants.viewHeight)
        
        setupViewHierarchy()
        layoutViews()
        setTitle(coinName: coinName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func setTitle(coinName name: String) {
        let attributedText = NSMutableAttributedString(string: "\(coinName) has been added to watchlist")
        
        let coinNameRange = NSRange(location: 0, length: name.count)
        let coinNameColor = UIColor.black
        attributedText.addAttribute(.foregroundColor, value: coinNameColor, range: coinNameRange)
        
        titleLabel.attributedText = attributedText
    }
    
    //MARK: - API
    
    func changeBottomConstraintConstant(to value: CGFloat ) {
        bottomConstraint.constant = value
    }
    
    func removeFromSuperview() {
        view.removeFromSuperview()
    }
}
    //MARK: - Setup Views

extension WatchlistPopUp {
    
    enum Constants {
        static let imageName = "checkmark"
        
        static let viewHeight: CGFloat = 52
        static let viewWidth: CGFloat = 232
        
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let viewCornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 2
    }
    
    private func setupViewHierarchy() {
        guard let superView else { return }
        
        superView.addSubviews(view)
        view.addSubviews(checkmarkLogo, titleLabel)
    }
    
    private func layoutViews() {
        guard let superView else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        checkmarkLogo.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.viewHeight),
            view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            view.widthAnchor.constraint(equalToConstant: Constants.viewWidth),
            bottomConstraint,
            
            
            checkmarkLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.smallPadding),
            checkmarkLogo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.smallPadding),
            checkmarkLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            checkmarkLogo.widthAnchor.constraint(equalTo: checkmarkLogo.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.smallPadding),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.smallPadding),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkLogo.trailingAnchor, constant: Constants.smallPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
        ])
    }
}
