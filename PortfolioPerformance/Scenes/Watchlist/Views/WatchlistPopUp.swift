import UIKit

final class WatchlistPopUp: UIView {
    
    private let coinName : String
    
    //MARK: - UI Elements
    
    private weak var superView: UIView?
    
    private let view: UIView = {
        let view  = UIView()
        view.configureWithShadow(cornerRadius: Constants.viewCornerRadius)
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.popUpBorder.cgColor
        view.backgroundColor = .popUpBackground
        return view
    }()
    
    private let checkmarkLogo = UIImageView(image: UIImage(named: Constants.imageName))
    
    private let titleLabel: PPTextLabel = {
        let label = PPTextLabel(textColor: .secondaryLabel)
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Init
    
    init(superView: UIView, coinName: String) {
        self.superView = superView
        self.coinName = coinName
        super.init(frame: .zero)
        setupViewHierarchy()
        layoutViews()
        setTitle(coinName: coinName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    
    private func setTitle(coinName name: String) {
        titleLabel.text = "\(coinName) has been added to watchlist"
    }
}

    //MARK: - Setup Views

extension WatchlistPopUp {
    
    private enum Constants {
        static let imageName = "checkmark"
        
        static let viewHeight: CGFloat = 52
        static let viewWeight: CGFloat = 232
        
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
            view.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            view.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.smallPadding),
            view.widthAnchor.constraint(equalToConstant: Constants.viewWeight),
            view.heightAnchor.constraint(equalToConstant: Constants.viewHeight),
            
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
