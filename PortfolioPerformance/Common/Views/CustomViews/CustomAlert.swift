import UIKit

class ErrorAlertVC: UIViewController {

    //MARK: - UI Eelements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.PPBlue.cgColor
        return view
    }()
    
    private let titleLabel: PPTextLabel = {
        let label = PPTextLabel(fontSize: 18, textColor: .label, allignment: .center, fontWeight: .bold)
        label.text = "Oops something went wrong"
        return label
    }()
    
    private let textLabel = PPTextLabel(
        fontSize: 18,
        textColor: .label,
        allignment: .center,
        fontWeight: .bold
    )
    
    private lazy var actionButton: PPButton = {
        let button = PPButton(color: .PPBlue, name: "Close")
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
            containerView.heightAnchor.constraint(equalToConstant: 220),
            containerView.widthAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupActionButton() {
        view.addSubview(actionButton)
        
        
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTextLabel() {
        containerView.addSubview(textLabel)
        
        textLabel.text = alertTitle
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

extension CustomAlert
