import UIKit

class ResultsCell: UITableViewCell {
    
    static let identifier = "ResultsCell"
    
    static let preferredHeight: CGFloat = 64
    
    var imageDownloader: ImageDownloaderProtocol?
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.layer.cornerRadius = 10
        logoView.clipsToBounds = true
        return logoView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        selectionStyle = .none
        logoContainerView.addSubview(logoView)
        contentView.addSubviews(symbolLabel, nameLabel, logoContainerView)
        viewLayout()
    }
    
    func viewLayout() {
        
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        logoView.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            logoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoContainerView.heightAnchor.constraint(equalToConstant: 40),
            logoContainerView.widthAnchor.constraint(equalTo: logoContainerView.heightAnchor),
            
            logoView.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor),
            logoView.topAnchor.constraint(equalTo: logoContainerView.topAnchor),
            logoView.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor),
            logoView.bottomAnchor.constraint(equalTo: logoContainerView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
            
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            symbolLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbolLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoView.image = nil
        imageDownloader?.cancelDownload()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    public func configure(withModel model: SearchResult) {
        symbolLabel.text = model.symbol.uppercased()
        nameLabel.text = model.name
        
        imageDownloader?.loadImage(from: model.image, completion: { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let (source, image)):
                    switch source {
                    case .downloaded:
                        self.logoView.fadeIn(image)
                    case .cached:
                        self.logoView.image = image
                    }
                case .failure(let error):
                    print(error)
                    //TODO: Handle error
                }
            }
        })
    }
    
    public func makeBottomCornersWithRadius() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

