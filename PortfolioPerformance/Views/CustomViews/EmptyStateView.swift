import UIKit

enum EmptyStateType {
    case noSearchResults
    case noFavourites
}

class EmptyStateView: UIView {
    
    //MARK: - Properties
    private let imageView: PPSegmentedProgressBar
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    //MARK: - Init
    init(type: EmptyStateType) {
        
        switch type {
        case .noFavourites:
            imageView = PPSegmentedProgressBar(frame: CGRect(x: 0, y: 0, width: 200, height: 200))//UIImageView(image: UIImage(named: "NoFavourites"))
            textLabel.text = "Favourite list  is empty"
        
        case .noSearchResults:
            imageView = PPSegmentedProgressBar(frame: .zero)//UIImageView(image: UIImage(named: "NoResult"))
            textLabel.text = "Sorry, nothing found"
        }
        super .init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(imageView, textLabel)
        isHidden = true
        setupConstraints()
    }
    
    private func setupConstraints() {
    
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 7 / 10),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 7 / 10),
            
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.widthAnchor.constraint(equalTo: widthAnchor),
            textLabel.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 2 / 10)
        ])
    }
}
