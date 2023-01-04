//
//  TransactionDetailsVC.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 03/01/2023.
//

import UIKit

final class TransactionDetailsVC: UIViewController {
    //TODO: text validation
    
    //MARK: - Properties
    
    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var coinLogoShadowView: UIImageView = {
        let view = UIImageView()
        view.configureWithShadow()
        view.backgroundColor = .logoBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var coinLogoView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var transactionTypeSegmentedControl: CustomSegmentedControl!
    
    private let transactionInputs = TransactionDetailsView(transactionType: .buy)
    
    private let addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .emerald
        button.setTitle("Add transaction", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 15
        return button
    }()
    
    //MARK: - Init
    
    init(model: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        configure(withModel: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        view.addSubviews(symbolLabel, coinLogoShadowView,transactionInputs, addTransactionButton, transactionTypeSegmentedControl)
        coinLogoShadowView.addSubview(coinLogoView)
        view.backgroundColor = .secondarySystemBackground
        addConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    //MARK: - Private methods
    
    private func configure(withModel model: SearchResult) {
        title = model.name
        symbolLabel.text = model.symbol.uppercased()
        coinLogoView.setImage(imageUrl: model.large)
    }
    
    private func setupSegmentedControl() {
        let items: [String] = [TransactionType.buy.rawValue, TransactionType.sell.rawValue, TransactionType.transfer.rawValue]
        transactionTypeSegmentedControl = CustomSegmentedControl(
            items: items,
            defaultColor: .emerald
        )
        transactionTypeSegmentedControl.addTarget(self, action: #selector(didChangeSegment(_:)) , for: .valueChanged)
        transactionTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func didChangeSegment(_ sender: UISegmentedControl) -> Void {
        transactionTypeSegmentedControl.updateBackgroundColor()
        switch sender.selectedSegmentIndex {
        case 0:
            addTransactionButton.backgroundColor = .emerald
        case 1:
            addTransactionButton.backgroundColor = .pomergranate
        case 2:
            addTransactionButton.backgroundColor = .PPblue
        default:
            fatalError()
        }
    }
    
    private func addConstraints() {
        symbolLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            coinLogoShadowView.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 20),
            coinLogoShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            coinLogoShadowView.heightAnchor.constraint(equalToConstant: 75),
            coinLogoShadowView.widthAnchor.constraint(equalToConstant: 75),
            
            coinLogoView.leadingAnchor.constraint(equalTo: coinLogoShadowView.leadingAnchor, constant: 10),
            coinLogoView.trailingAnchor.constraint(equalTo: coinLogoShadowView.trailingAnchor, constant: -10),
            coinLogoView.topAnchor.constraint(equalTo: coinLogoShadowView.topAnchor, constant: 10),
            coinLogoView.bottomAnchor.constraint(equalTo: coinLogoShadowView.bottomAnchor, constant: -10),
            
            transactionTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transactionTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            transactionTypeSegmentedControl.topAnchor.constraint(equalTo: coinLogoShadowView.bottomAnchor, constant: 10),
            transactionTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            transactionInputs.topAnchor.constraint(equalTo: transactionTypeSegmentedControl.bottomAnchor, constant: 10),
            transactionInputs.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            transactionInputs.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            transactionInputs.heightAnchor.constraint(equalToConstant: 190),
            
            addTransactionButton.topAnchor.constraint(equalTo: transactionInputs.bottomAnchor, constant: 10),
            addTransactionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addTransactionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
