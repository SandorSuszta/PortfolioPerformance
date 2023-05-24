import UIKit

class CryptoCurrencyCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CryptoCurrencyCell"
    
    static let prefferredHeight: CGFloat = 64
    
    var imageDownloader: ImageDownloaderProtocol?
    
    private let nameLabel = PPTextLabel(allignment: .left, fontWeight: .medium)
    private let symbolLabel = PPTextLabel(textColor: .secondaryLabel, allignment: .left)
    private let priceLabel = PPTextLabel(allignment: .right, fontWeight: .medium)
    private let changeLabel = PPTextLabel(allignment: .right)
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.viewCornerRadius
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let labelsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.viewCornerRadius
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureContentView()
        setupViewHierarchy()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        
        imageDownloader?.cancelDownload()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        UIView.animate(withDuration: 0.3) {
            self.priceLabel.alpha = editing ? 0 : 1
            self.changeLabel.alpha = editing ? 0 : 1
        }
    }
    
    //MARK: - Private Methods
    
    private func configureContentView() {
        contentView.backgroundColor = .systemBackground
    }
    
    func configureCell(with viewModel: CryptoCurrencyCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.currentPrice
        changeLabel.text = viewModel.priceChangePercentage24H
        changeLabel.textColor = viewModel.coinModel.priceChange24H ?? 0 >= 0 ? .nephritis : .pomergranate
        
        imageDownloader?.loadImage(from: viewModel.imageUrl, completion: { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let (source, image)):
                
                switch source {
                case .downloaded:
                    self.logoImageView.fadeIn(image)
                case .cached:
                    self.logoImageView.image = image
                }
                
            case .failure(let error):
                //TODO: Handle error
                print(error)
            }
        })
        
        selectionStyle = .none
    }
}

    //MARK: - View Layout

private extension CryptoCurrencyCell {
    
    enum Constants {
        static let viewCornerRadius  = 8.0
        static let logoViewHeight    = 40.0
        static let nameLabelHeight   = 18.0
        static let symbolLabelHeight = 16.0
        static let logoContainerViewPadding = 16.0
    }
    
    func setupViewHierarchy() {
        contentView.addSubviews(logoContainerView, labelsContainerView)
        logoContainerView.addSubviews(logoImageView)
        labelsContainerView.addSubviews(nameLabel, symbolLabel, priceLabel, changeLabel)
    }
    
    func setupViewLayout() {
        
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        symbolLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            logoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoContainerView.heightAnchor.constraint(equalToConstant: Constants.logoViewHeight),
            logoContainerView.widthAnchor.constraint(equalToConstant: Constants.logoViewHeight),
            
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor),
            logoImageView.widthAnchor.constraint(equalTo: logoContainerView.widthAnchor),
            
            labelsContainerView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            labelsContainerView.leadingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: Constants.logoContainerViewPadding),
            labelsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.logoContainerViewPadding),
            labelsContainerView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: Constants.nameLabelHeight),
            
            symbolLabel.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor, constant: -2),
            symbolLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: changeLabel.leadingAnchor, constant: -8),
            symbolLabel.heightAnchor.constraint(equalToConstant: Constants.symbolLabelHeight),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            changeLabel.bottomAnchor.constraint(equalTo: symbolLabel.bottomAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            changeLabel.heightAnchor.constraint(equalTo: symbolLabel.heightAnchor),
        ])
    }
}
