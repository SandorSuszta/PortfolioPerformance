import UIKit

final class HighlightsView: UIView {
    
    static let prefferedHeight: CGFloat = 152
    
    // MARK: - UI Elements
    
    private let symbolLabel =  PPTextLabel(
        fontSize: 16,
        allignment: .center,
        fontWeight: .semibold
    )
    
    private let priceLabel =  PPTextLabel(
        fontSize: 30,
        allignment: .center,
        fontWeight: .regular,
        alpha: 0
    )
    
     private let priceChangeLabel =  PPTextLabel(
        fontSize: 14,
        fontWeight: .semibold,
        alpha: 0
    )
    
    private let priceChangePercentageLabel =  PPTextLabel(
        fontSize: 14,
        fontWeight: .semibold,
        alpha: 0
    )
    
    private var coinLogoShadowView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.addShadow()
        return view
    }()
    
    private var coinLogoView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - API
    
    func setSymbolName(_ symbol: String) {
        symbolLabel.text = symbol
    }
    
    func setCurrentPrice(_ price: String) {
        priceLabel.text = price
        priceLabel.fadeIn()
    }
    
    func setPriceChangeLabels(priceChange: String, inPercentage percentage: String, color: UIColor) {
        priceChangeLabel.textColor = color
        priceChangeLabel.text = priceChange
        priceChangeLabel.fadeIn()
        
        priceChangePercentageLabel.textColor = color
        priceChangePercentageLabel.text = percentage
        priceChangePercentageLabel.fadeIn()
    }

    func setLogo(_ logo: UIImage) {
        coinLogoView.image = logo
    }
    
    func fadeOutChangeLabels() {
        priceChangeLabel.fadeOut()
        priceChangePercentageLabel.fadeOut()
    }
    
    func fadeInChangeLabels() {
        priceChangeLabel.fadeIn()
        priceChangePercentageLabel.fadeIn()
    }
}

    // MARK: - Setup views

extension HighlightsView {
    
    private enum Constants {
        static let logoTopPadding: CGFloat  = 20
        static let logoLeftPadding: CGFloat = 36
        static let logoSize: CGFloat = 84
        static let logoInset: CGFloat = 8
        static let priceLabelTopPadding: CGFloat = 16
        static let priceLabelLeftPadding: CGFloat = 36
        static let priceChangeLabelTopPadding: CGFloat = 4
        static let priceChangePercentageLabelLeftPadding: CGFloat = 4
    }
    
    private func setupHierarchy() {
        addSubviews(
            symbolLabel,
            priceLabel,
            priceChangeLabel,
            priceChangePercentageLabel,
            coinLogoShadowView
        )
        coinLogoShadowView.addSubview(coinLogoView)
    }
    
    private func setupLayout() {
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceChangePercentageLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLogoShadowView.translatesAutoresizingMaskIntoConstraints = false
        coinLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            coinLogoShadowView.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: Constants.logoTopPadding),
            coinLogoShadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.logoLeftPadding),
            coinLogoShadowView.heightAnchor.constraint(equalToConstant: Constants.logoSize),
            coinLogoShadowView.widthAnchor.constraint(equalToConstant: Constants.logoSize),
            
            coinLogoView.topAnchor.constraint(equalTo: coinLogoShadowView.topAnchor, constant: Constants.logoInset),
            coinLogoView.leadingAnchor.constraint(equalTo: coinLogoShadowView.leadingAnchor, constant: Constants.logoInset),
            coinLogoView.trailingAnchor.constraint(equalTo: coinLogoShadowView.trailingAnchor, constant: -Constants.logoInset),
            coinLogoView.bottomAnchor.constraint(equalTo: coinLogoShadowView.bottomAnchor, constant: -Constants.logoInset),
            
            priceLabel.topAnchor.constraint(equalTo: coinLogoShadowView.topAnchor, constant: Constants.priceLabelTopPadding),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.priceLabelLeftPadding),
            
            priceChangeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.priceChangeLabelTopPadding),
            priceChangeLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            
            priceChangePercentageLabel.topAnchor.constraint(equalTo: priceChangeLabel.topAnchor),
            priceChangePercentageLabel.leadingAnchor.constraint(equalTo: priceChangeLabel.trailingAnchor, constant: Constants.priceChangePercentageLabelLeftPadding)
        ])
    }
}
