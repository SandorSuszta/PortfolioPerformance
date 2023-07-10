import UIKit

class MarketCardBaseCell: UICollectionViewCell {
    
    let headerTitle = PPTextLabel(fontSize: 16, textColor: .secondaryLabel, fontWeight: .medium)
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureContentView()
        contentView.applyShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 15
    }
    
    internal func configureLayout() {
        contentView.addSubview(headerTitle)
        let padding = width / 15
        
        NSLayoutConstraint.activate([
            headerTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            headerTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headerTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headerTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.11)
        ])
    }
}
