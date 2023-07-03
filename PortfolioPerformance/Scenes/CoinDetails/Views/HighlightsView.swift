import UIKit

final class HighlightsView: UIView {
    
    static let prefferedHeight: CGFloat = 160
    
    // MARK: - UI Elements
    
    private let symbolLabel =  PPTextLabel(
        fontSize: 16,
        allignment: .center,
        fontWeight: .semibold
    )
    
    private let priceLabel =  PPTextLabel(
        fontSize: 30,
        allignment: .center,
        fontWeight: .regular
    )
    
     private let priceChangeLabel =  PPTextLabel(
        fontSize: 14,
        fontWeight: .semibold
    )
    
    private let priceChangePercentageLabel =  PPTextLabel(
        fontSize: 14,
        fontWeight: .semibold
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
    
    init(forCoin: CoinRepresenatable) {
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
    }
    
    func setPriceChangeLabels(priceChange: String, inPercentage: String, color: UIColor) {
        priceChangeLabel.text = priceChange
        priceChangeLabel.textColor = color
        
        priceChangePercentageLabel.text = inPercentage
        priceChangePercentageLabel.textColor = color
    }

    func setLogo(_ logo: UIImage) {
        coinLogoView.image = logo
    }
}

    // MARK: - Setup views

extension HighlightsView {
    
    private enum Constants {
        
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
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            coinLogoShadowView.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 20),
            coinLogoShadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 120),
            coinLogoShadowView.heightAnchor.constraint(equalToConstant: 84),
            coinLogoShadowView.widthAnchor.constraint(equalToConstant: 84),
            
            coinLogoView.topAnchor.constraint(equalTo: coinLogoShadowView.topAnchor, constant: 8),
            coinLogoView.leadingAnchor.constraint(equalTo: coinLogoShadowView.leadingAnchor, constant: 8),
            coinLogoView.trailingAnchor.constraint(equalTo: coinLogoShadowView.trailingAnchor, constant: -8),
            coinLogoView.bottomAnchor.constraint(equalTo: coinLogoShadowView.bottomAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: coinLogoShadowView.topAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            
            priceChangeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            priceChangeLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            
            priceChangePercentageLabel.topAnchor.constraint(equalTo: priceChangeLabel.topAnchor),
            priceChangePercentageLabel.leadingAnchor.constraint(equalTo: priceChangeLabel.leadingAnchor, constant: 4)
        ])
    }
}
