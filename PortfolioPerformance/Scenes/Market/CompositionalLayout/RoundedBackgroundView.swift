import UIKit

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
        addSubview(insetView)
        insetView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            insetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            trailingAnchor.constraint(equalTo: insetView.trailingAnchor, constant: 15),
            insetView.topAnchor.constraint(equalTo: topAnchor),
            insetView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
