import UIKit

class ErrorAlertVC: UIViewController {

    //MARK: - UI Eelements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.configureWithShadow()
        return view
    }()
    
    private let titleLabel: PPTextLabel = {
        let label = PPTextLabel(fontSize: Constants.titleFontSize, textColor: .label, allignment: .center, fontWeight: .bold)
        label.text = Constants.titleText
        label.numberOfLines = 0
        return label
    }()
    
    private let textLabel = PPTextLabel(
        fontSize: Constants.textFontSize,
        textColor: .label,
        allignment: .center,
        fontWeight: .bold
    )
    
    private lazy var actionButton: PPButton = {
        let button = PPButton(color: .PPBlue, name: Constants.buttonTitle)
        button.addTarget(self, action: #selector(didPressActionButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    init(text: String) {
        super .init(nibName: nil, bundle: nil)
        self.textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground.withAlphaComponent(0.95)
        setupViews()
    }
    
    //MARK: - UI Elements Event handlers

//        textLabel.text = alertTitle
//        textLabel.textColor = .label
//        textLabel.textAlignment = .center
//        textLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//        textLabel.adjustsFontSizeToFitWidth = true
//        textLabel.minimumScaleFactor = 0.75
//        textLabel.numberOfLines = 0
//        textLabel.lineBreakMode = .byWordWrapping
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
    @objc func didPressActionButton() {
        dismiss(animated: true)
    }
}

//MARK: - Setup Views

private extension ErrorAlertVC {
    enum Constants {
        static let titleFontSize: CGFloat =     18
        static let textFontSize: CGFloat =      16
        
        static let padding: CGFloat =           20
        static let smallPadding: CGFloat =      12
        static let buttonHeight: CGFloat =      44
        static let containerHeight: CGFloat =   220
        static let containerWidth: CGFloat =    260
        
        static let titleText = "Oops... something went wrong"
        static let buttonTitle = "Close"
    }
    
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, textLabel, actionButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Constants.containerHeight),
            containerView.widthAnchor.constraint(equalToConstant: Constants.containerWidth),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.smallPadding),
            textLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -Constants.smallPadding),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}
