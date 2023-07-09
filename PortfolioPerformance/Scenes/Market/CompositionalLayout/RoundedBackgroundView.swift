import UIKit

///This view is used as a decoration view in a `UICollectionViewCompositionalLayout` to make section have a rounded edge appearence
final class RoundedBackgroundView: UICollectionReusableView {
    
    static let reuseID = String(describing: RoundedBackgroundView.self)
    
    //MARK: - UI Elements

    private var insetView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViewsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupViewsLayout() {
        
        enum Constants {
            static let padding: CGFloat = 15
        }
        
        addSubview(insetView)
        insetView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            insetView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            insetView.topAnchor.constraint(equalTo: topAnchor, constant: 52),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
