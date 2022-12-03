import UIKit

class CustomAlertVC: UIViewController {
    
    public var alertText: String

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.PPblue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let actionButton = PPButton(color: .PPblue, name: "Close")
    
    //MARK: - Init
    init(text: String) {
        self.alertText = text
        super .init(nibName: nil, bundle: nil)
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
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            containerView.widthAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = "Oops something went wrong"
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupActionButton() {
        view.addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTextLabel() {
        containerView.addSubview(textLabel)
        
        textLabel.text = alertText
        textLabel.textColor = .label
        textLabel.textAlignment = .center
        textLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.75
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
