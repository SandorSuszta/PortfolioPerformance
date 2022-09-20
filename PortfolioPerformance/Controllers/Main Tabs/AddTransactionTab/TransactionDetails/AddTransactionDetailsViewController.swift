//
//  AddTransactionParentViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 30/05/2022.
//TODO: Add Chevron To Button
//TODO: Animate UIButton
//TODO: Show Error When Empty Field

import Foundation
import UIKit

class AddTransactionDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel: AddTransactionParentViewControllerViewModel?
    
    private var transactionType = "buy"
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        return view
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let tradingPairLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    let tradingPairButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.addTarget(AddTransactionDetailsViewController.self, action: #selector(didClickTradingPairButton), for: .touchUpInside)
        return button
    }()
    
    let transactionTypeSegmentedContol : UISegmentedControl = {
        let segment = UISegmentedControl(
            items: ["Buy","Sell","Convert","Transfer"]
        )
        return segment
    }()
    
    private let transactionDetailsView: UIView = {
        let view = UIView()
        view.configureWithShadow()
        return view
    }()
    
    let priceInputView: FloatingLabelInputView = {
        let view = FloatingLabelInputView()
        view.floatingLabel.text = "Enter price"
        return view
    }()
    
    let ammountInputView: FloatingLabelInputView = {
        let view = FloatingLabelInputView()
        view.floatingLabel.text = "Enter ammount"
        return view
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    let addButton: AddTransactionButton = {
        let button = AddTransactionButton(color: .nephritis)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(AddTransactionDetailsViewController.self, action: #selector(didPressAddTransactionButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clouds
        self.navigationController?.navigationBar.tintColor = .black
        
        updateUIFromViewModel()
        setupSegmentedControl()

        view.addSubviews(
            symbolLabel,
            logoContainerView,
            tradingPairLabel,
            tradingPairButton,
            transactionTypeSegmentedContol,
            transactionDetailsView,
            addButton
        )
        
        transactionDetailsView.addSubviews(
            priceInputView,
            ammountInputView,
            datePicker
        )
        
        logoContainerView.addSubview(logoImageView)
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        symbolLabel.sizeToFit()
        tradingPairLabel.sizeToFit()
        tradingPairButton.sizeToFit()
        transactionTypeSegmentedContol.sizeToFit()
        
        
        symbolLabel.frame = CGRect(
            x: (view.width - symbolLabel.width)/2,
            y: view.safeAreaInsets.bottom + 10,
            width: symbolLabel.width,
            height: symbolLabel.height
        )
        
        logoContainerView.frame = CGRect(
            x: view.right - 125,
            y: symbolLabel.bottom + 30,
            width: 85,
            height: 85
        )
        
        logoImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: 75,
            height: 75
        )
        
        transactionTypeSegmentedContol.frame = CGRect(
            x: view.width/2 - (transactionTypeSegmentedContol.width + 20)/2,
            y: logoContainerView.bottom + 30,
            width: transactionTypeSegmentedContol.width + 20,
            height: transactionTypeSegmentedContol.height
        )
        
        tradingPairLabel.frame = CGRect(
            x: transactionTypeSegmentedContol.left,
            y: logoContainerView.top + logoContainerView.height/2 - (tradingPairLabel.height + tradingPairButton.height)/2,
            width: tradingPairLabel.width,
            height: tradingPairLabel.height
        )

        tradingPairButton.frame = CGRect(
            x: tradingPairLabel.left,
            y: tradingPairLabel.bottom,
            width: tradingPairButton.width + 20,
            height: tradingPairButton.height)
        
        transactionDetailsView.frame = CGRect(
            x: 20,
            y: transactionTypeSegmentedContol.bottom + 20,
            width: view.width - 40,
            height: 160
        )
        
        priceInputView.frame = CGRect(
            x: 20,
            y: 0,
            width: transactionDetailsView.width - 40,
            height: 50
        )
        
        ammountInputView.frame = CGRect(
            x: 20,
            y: priceInputView.bottom,
            width: transactionDetailsView.width - 40,
            height: 50
        )
        
        datePicker.frame = CGRect(
            x: 20,
            y: ammountInputView.bottom + 10,
            width: view.width - 40,
            height: datePicker.height
        )
        
        addButton.frame = CGRect(
            x: 20,
            y: transactionDetailsView.bottom + 20,
            width: view.width - 40,
            height: 50
        )
        
    }
    
    //MARK: - Methods

    private func updateUIFromViewModel() {
        
        title = viewModel?.coinName
        
        symbolLabel.text = viewModel?.coinSymbol
        
        tradingPairLabel.text = "Trading Pair"
        
        tradingPairButton.setTitle(
            (viewModel?.coinSymbol ?? "") + " / " + (viewModel?.tradingPair ?? ""),
            for: .normal
        )
        
        tradingPairButton.setTitleColor(.black, for: .normal)
        
        logoImageView.setImage(
            imageData: viewModel?.coinLogoData,
            imageUrl:  viewModel?.coinLogoUrl ?? ""
        )
    }
    
    private func setupSegmentedControl() {
        transactionTypeSegmentedContol.selectedSegmentIndex = 0
        transactionTypeSegmentedContol.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    @objc private func didChangeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            transactionType = "buy"
            addButton.backgroundColor = .nephritis
        case 1:
            transactionType = "sell"
            addButton.backgroundColor = .pomergranate
        case 2:
            transactionType = "convert"
            addButton.backgroundColor = .carrot
        case 3:
            transactionType = "transfer"
            addButton.backgroundColor = .navy
        default:
            fatalError()
        }
    }
    
    @objc private func didPressAddTransactionButton(_ sender: UIButton) {
        let newTransaction = createTransactionModel()
        PersistanceManager.updateHoldingsWithNewTransaction(transaction: newTransaction)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didClickTradingPairButton(_ sender: UIButton) {
        let vc = SearchScreenViewController()
        vc.delegate = self
        vc.rootViewController = .transactionDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createTransactionModel() -> Transaction {
        let transaction = Transaction(context: PersistanceManager.context)
        transaction.type = transactionType
        transaction.price = Double(priceInputView.textField.text!) ?? 0
        transaction.ammount = Double(ammountInputView.textField.text!) ?? 0
        transaction.dateAndTime = datePicker.date
        transaction.boughtCurrency = viewModel?.coinSymbol
        transaction.convertedCurrency = viewModel?.tradingPair
        transaction.logo = viewModel?.coinLogoData
        return transaction
    }
}

//MARK: - Search Controller Delegate Method

extension AddTransactionDetailsViewController: SearchViewControllerDelegate {
    func didSelectCoin(coinName: String) {
        DispatchQueue.main.async {
            self.tradingPairButton.setTitle(
                (self.viewModel?.coinSymbol ?? "") + " / " + coinName,
                for: .normal
            )
        }
    }
}
