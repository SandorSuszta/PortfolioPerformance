import UIKit

final class HighlightsView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        
    }
}
