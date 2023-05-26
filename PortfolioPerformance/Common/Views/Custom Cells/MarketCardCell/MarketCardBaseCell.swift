import UIKit

enum MarketCardCellType: String {
    case greedAndFear = "Greed And Fear"
    case totalMarketCap = "Total Market Cap"
    case bitcoinDominance = "Bitcoin Dominance"
    
    var cellTitle: String { self.rawValue }
}

class MarketCardBaseCell: UICollectionViewCell {
    
    let headerTitle = PPTextLabel(fontSize: 18, fontWeight: .medium)
    
    //MARK: - Init
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureContentView()
        contentView.configureWithShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 15
    }
    
    internal func configureLayout() {
        contentView.addSubview(headerTitle)
        let padding = width / 15
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            headerTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headerTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headerTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.125)
        ])
    }
}
