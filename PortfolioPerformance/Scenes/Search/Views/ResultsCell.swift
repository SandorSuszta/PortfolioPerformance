import UIKit

class ResultsCell: UITableViewCell {
    
    static let identifier = "ResultsCell"
    static let preferredHeight: CGFloat = 60
    
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
        logoContainerView.addSubview(logoView)
        contentView.addSubviews(symbolLabel, nameLabel, logoContainerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        logoView.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.backgroundColor = .yellow
        
        NSLayoutConstraint.activate([
        
            logoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            logoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            logoContainerView.widthAnchor.constraint(equalToConstant: contentView.bounds.height - 20),
            logoContainerView.heightAnchor.constraint(equalToConstant: contentView.bounds.height - 20),
            
            logoView.leadingAnchor.constraint(equalTo: logoContainerView.leadingAnchor, constant: 5),
            logoView.topAnchor.constraint(equalTo: logoContainerView.topAnchor, constant: 5),
            logoView.trailingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: -5),
            logoView.bottomAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: -5),
            
            nameLabel.leadingAnchor.constraint(equalTo: logoContainerView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
            
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
        })
    }
    
    public func makeBottomCornersWithRadius() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

