import UIKit

class AddTransactionCell: UICollectionViewCell {
    
    static let identifier = "AddTransactionCell"
    
    var model: SearchResult?
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.cornerRadius = 15
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    
    public func configure(withModel model: SearchResult?) {
        guard let model = model else { return }
        
        self.model = model
        symbolLabel.text = model.symbol.uppercased()
        logoView.setImage(from: model.large)
    }
    
    //MARK: - Private methods
    
    private func setupViews() {
        contentView.addSubviews(symbolLabel, logoView)
        setupConstraints()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            logoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor),
            
            symbolLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 6),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
