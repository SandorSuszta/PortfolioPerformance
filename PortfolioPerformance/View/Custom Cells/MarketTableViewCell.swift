import UIKit

class MarketTableViewCell: UITableViewCell {
    
    static let identifier = "MarketTableCell"
    static let prefferedHeight: CGFloat = 60
    
    struct ViewModel {
        let name: String
        let symbol: String
        let price: String
        let change: String
        let imageUrl: String
        let imageData: Data?
        let changeIsGreaterThenZero: Bool
        
        init(model: CoinModel) {
            self.name = model.name
            self.symbol = model.symbol.uppercased()
            self.price = model.currentPrice.string2f()
            self.change = (model.priceChangePercentage24H ?? 0).string2f() + "%"
            self.imageData = model.imageData
            self.imageUrl = model.image
            self.changeIsGreaterThenZero = model.priceChangePercentage24H ?? 0 >= 0 ? true : false
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.configureWithShadow()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        backgroundColor = nil
        
        logoContainerView.addSubview(logoImageView)
        addSubviews(nameLabel, symbolLabel, priceLabel, changeLabel, logoContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 20
        logoContainerView.frame = CGRect(
            x: contentView.left + 10,
            y: 10,
            width: imageSize,
            height: imageSize
        )
        
        logoImageView.frame = CGRect(
            x: 2,
            y: 2,
            width: imageSize - 4 ,
            height: imageSize - 4
        )
        
        nameLabel.frame = CGRect(
            x: logoContainerView.right + 20,
            y: contentView.height/2 - nameLabel.height,
            width: (contentView.width - imageSize)/2,
            height: 20
        )
        
        symbolLabel.frame = CGRect(
            x: nameLabel.left,
            y: nameLabel.bottom,
            width: (contentView.width - imageSize)/2,
            height: 20)
        
        priceLabel.frame = CGRect(
            x: contentView.right - priceLabel.width - 10,
            y: nameLabel.top,
            width: symbolLabel.width - 10,
            height: 20)
        
        changeLabel.frame = CGRect(
            x: priceLabel.left,
            y: priceLabel.bottom,
            width: priceLabel.width,
            height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configureCell(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        
        changeLabel.text = {
            let prefix = viewModel.changeIsGreaterThenZero ? "+" : ""
            let text = prefix + viewModel.change + "%"
            return text
        }()
        
        changeLabel.textColor = viewModel.changeIsGreaterThenZero ? .nephritis : .pomergranate
        
        logoImageView.setImage(imageData: viewModel.imageData, imageUrl: viewModel.imageUrl)
    }
}

