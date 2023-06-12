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
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
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
        view.backgroundColor = .systemBackground.withAlphaComponent(0.75)
        setupContainerView()
        setupTitleLabel()
        setupActionButton()
        setupTextLabel()
    }
    
    //MARK: - Private methods
    
    private func setupContainerView() {
        view.addSubview(containerView)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Constants.containerHeight),
            containerView.widthAnchor.constraint(equalToConstant: Constants.containerWidth)
        ])
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
    }
    
    private func setupActionButton() {
        view.addSubview(actionButton)
        
        
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    private func setupTextLabel() {
        containerView.addSubview(textLabel)
        
//        textLabel.text = alertTitle
//        textLabel.textColor = .label
//        textLabel.textAlignment = .center
//        textLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//        textLabel.adjustsFontSizeToFitWidth = true
//        textLabel.minimumScaleFactor = 0.75
//        textLabel.numberOfLines = 0
//        textLabel.lineBreakMode = .byWordWrapping
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.smallPadding),
            textLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -Constants.smallPadding),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding)
        ])
    }
    
    @objc func dismissVC() {
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
        static let titleHeight: CGFloat =       24
        static let buttonHeight: CGFloat =      44
        static let containerHeight: CGFloat =   220
        static let containerWidth: CGFloat =    260
        
        static let titleText = "Oops something went wrong"
        static let buttonTitle = "Close"
    }
}
