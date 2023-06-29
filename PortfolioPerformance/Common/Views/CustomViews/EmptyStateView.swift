import UIKit

final class EmptyStateView: UIView {
    
    //MARK: - UI Elements
    
    private let imageView: UIImageView
    
    private var titleLabel = PPTextLabel(
        fontSize: Constants.titleFontSize,
        textColor: .secondaryLabel,
        allignment: .center,
        fontWeight: .bold
    )
    
    //MARK: - Init
    
    init(type: EmptyState) {
        imageView = UIImageView(image: UIImage(named: type.imageName))
        super .init(frame: .zero)
        titleLabel.text = type.title
        isHidden = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    //MARK: - Setup Views

private extension EmptyStateView {
    
    enum Constants {
        static let titleFontSize: CGFloat = 26
        static let imageWidthToViewWidthMultiplier: CGFloat = 7 / 10
        static let titleHeightToViewHeightMultiplier: CGFloat = 2 / 10
    }
    
    func setupViews() {
        addSubviews(imageView, titleLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.imageWidthToViewWidthMultiplier),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.imageWidthToViewWidthMultiplier),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.titleHeightToViewHeightMultiplier)
        ])
    }
}
