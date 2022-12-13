import UIKit

class AddTransactionCell: UICollectionViewCell {
    
    static let identifier = "ResultsCell"
    static let preferredHeight: CGFloat = 50
    static let prefrredWidth: CGFloat = 80
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.layer.cornerRadius = 10
        logoView.clipsToBounds = true
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWithShadow()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    
    public func configure(with searchResult: SearchResult) {
        symbolLabel.text = searchResult.symbol.uppercased()
        nameLabel.text = searchResult.name
        logoView.setImage(imageUrl: searchResult.large)
    }
    
    //MARK: - Private methods
    
    private func setupViews() {
        contentView.addSubviews(symbolLabel, nameLabel, logoView)
        setupConstraints()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
