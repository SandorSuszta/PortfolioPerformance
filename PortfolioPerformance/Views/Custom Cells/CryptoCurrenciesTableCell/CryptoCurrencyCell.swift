import UIKit

class CryptoCurrencyCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CryptoCurrencyCell"
    static let prefferredHeight: CGFloat = 56
    
    var imageDownloader: ImageDownloaderProtocol?
    
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
    
    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureContentView()
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
        priceLabel.isHidden = editing
        changeLabel.isHidden = editing
    }
    
    //MARK: - Methods
    
    func configureCell(with viewModel: CryptoCurrencyCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.currentPrice
        changeLabel.text = viewModel.priceChangePercentage24H
        changeLabel.textColor = viewModel.coinModel.priceChange24H ?? 0 >= 0 ? .nephritis : .pomergranate
        
        imageDownloader?.loadImage(from: viewModel.imageUrl, completion: { [weak self] result in
            switch result {
            case .success(let image):
                self?.logoImageView.image = image
            case .failure(let error):
                //TODO: Handle error
                print(error)
            }
        })
        selectionStyle = .none
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubviews(logoContainerView, labelsContainerView)
        logoContainerView.addSubviews(logoImageView)
        labelsContainerView.addSubviews(nameLabel, symbolLabel, priceLabel, changeLabel)
        
        NSLayoutConstraint.activate([
            logoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoContainerView.heightAnchor.constraint(equalToConstant: 36),
            logoContainerView.widthAnchor.constraint(equalToConstant: 36),
            
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor),
            logoImageView.widthAnchor.constraint(equalTo: logoContainerView.widthAnchor),
            
            labelsContainerView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            labelsContainerView.leadingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: 16),
            labelsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelsContainerView.heightAnchor.constraint(equalTo: logoContainerView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            symbolLabel.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            symbolLabel.heightAnchor.constraint(equalToConstant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            changeLabel.bottomAnchor.constraint(equalTo: symbolLabel.bottomAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            changeLabel.heightAnchor.constraint(equalTo: symbolLabel.heightAnchor),
        ])
    }
}
