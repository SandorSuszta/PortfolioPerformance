import UIKit

final class DetailsTableViewHeader: UIView {
    
    static let prefferedHeight = 44.0
  
    // MARK: - UI Elements
    
    let detailsLabel = PPTextLabel(fontWeight: .medium)
    let marketCapRankLabel = PPTextLabel(fontWeight: .medium)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    func setMarketCapRank(_ rank: String) {
        marketCapRankLabel.text = "#\(rank)"
    }
    
    // MARK: - Private
    
    private func configure() {
        detailsLabel.text = "Details"
        
        addSubviews(detailsLabel, marketCapRankLabel)
        
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        marketCapRankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailsLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            
            marketCapRankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            marketCapRankLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            marketCapRankLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor)
        ])
    }
}
