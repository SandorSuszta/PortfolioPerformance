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
        
        let imageSize: CGFloat = contentView.height - 20
        
        logoContainerView.frame = CGRect(
            x: contentView.left + 10,
            y: 10,
            width: imageSize,
            height: imageSize
        )
        
        logoView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize - 10,
            height: imageSize - 10
        )
        
        symbolLabel.sizeToFit()
        symbolLabel.frame = CGRect(
            x: logoContainerView.right + 10,
            y: 0,
            width: symbolLabel.width,
            height: contentView.height
        )
        
        nameLabel.frame = CGRect(
            x: symbolLabel.right + 10,
            y: 0,
            width: contentView.width - logoView.width - symbolLabel.width,
            height: contentView.height
        )
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
        
        imageDownloader?.loadImage(from: model.large, completion: { result in
            switch result {
            case .success(let image):
                self.logoView.image = image
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

