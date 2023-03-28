import UIKit

class CryptoCurrencyCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CryptoCurrencyCell"
    
    private let nameLabel = PPTextLabel(allignment: .left, fontWeight: .medium)
    private let symbolLabel = PPTextLabel(textColor: .secondaryLabel, allignment: .left)
    private let priceLabel = PPTextLabel(allignment: .right, fontWeight: .medium)
    private let changeLabel = PPTextLabel(allignment: .right)
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Methods
    
    func configureCell(with viewModel: CryptoCurrencyCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.currentPrice
        changeLabel.text = viewModel.priceChangePercentage24H
        changeLabel.textColor = viewModel.coinModel.priceChange24H ?? 0 >= 0 ? .nephritis : .pomergranate
        
        logoImageView.setImage(imageUrl: viewModel.imageUrl)
        selectionStyle = .none
    }
    
    func makeBottomCornersWithRadius() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        clipsToBounds = true
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .systemBackground
        
        addSubviews(logoContainerView, labelsContainerView)
        logoContainerView.addSubviews(logoImageView)
        labelsContainerView.addSubviews(nameLabel, symbolLabel, priceLabel, changeLabel)
        
        let padding = height / 3
        
        NSLayoutConstraint.activate([
            logoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            logoContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            logoContainerView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7 ),
            
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor, multiplier: 0.9),
            logoImageView.widthAnchor.constraint(equalTo: logoContainerView.widthAnchor, multiplier: 0.9),
            
            labelsContainerView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            labelsContainerView.leadingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: padding),
            labelsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            labelsContainerView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor, multiplier: 0.8),
            
            nameLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalTo: labelsContainerView.heightAnchor, multiplier: 0.5),
            
            symbolLabel.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            symbolLabel.heightAnchor.constraint(equalTo: labelsContainerView.heightAnchor, multiplier: 0.4),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            changeLabel.bottomAnchor.constraint(equalTo: symbolLabel.bottomAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            changeLabel.heightAnchor.constraint(equalTo: symbolLabel.heightAnchor),
            
        ])
    }
}
