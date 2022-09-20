//
//  AddTransactionChildViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 06/06/2022.
//

import Foundation
import UIKit

class AddTransactionChildViewController: UIViewController {
    
    //MARK: - Properties
    
    private let transactionType: String
    
    private let currentCoinSymbol: String
    
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
        button.addTarget(AddTransactionChildViewController.self, action: #selector(didPressAddTransaction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(transactionType: String, currentCoinSymbol: String) {
        self.transactionType = transactionType
        self.currentCoinSymbol = currentCoinSymbol
        super .init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(
            priceInputView,
            ammountInputView,
            datePicker,
            addButton
        )
        
        priceInputView.backgroundColor = .clear
        view.configureWithShadow()
        switchTransactionType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        priceInputView.frame = CGRect(
            x: 20,
            y: 0,
            width: view.width - 40,
            height: 50
        )
        
        ammountInputView.frame = CGRect(
            x: 20,
            y: priceInputView.bottom,
            width: view.width,
            height: 50
        )
        
        datePicker.frame = CGRect(
            x: 20,
            y: ammountInputView.bottom + 20,
            width: view.width - 40,
            height: datePicker.height
        )
        
        addButton.frame = CGRect(
            x: 0,
            y: datePicker.bottom + 30,
            width: view.width,
            height: 50
        )
    }
    
    //MARK: - Methods
    
    private func switchTransactionType() {
        
        switch transactionType {
        case "buy":
            addButton.backgroundColor = .nephritis
        case "sell":
            addButton.backgroundColor = .pomergranate
        case "convert":
            addButton.backgroundColor = .carrot
        case "transfer":
            addButton.backgroundColor = .navy
        default:
            fatalError()
        }
    }
    
    @objc private func didPressAddTransaction() {
        //        func saveBuyTransaction() {
        //            let newTransaction = Transaction(context: PersistanceManager.context)
        //            let selectedCoin = AddTransactionViewController.selectedCoin
        //
        //            newTransaction.type = "buy"
        //            newTransaction.ammount = Double(buyAmmountTextField.text!) ?? 0
        //            newTransaction.price = Double(buyPriceTextField.text!) ?? 0
        //            newTransaction.dateAndTime = buyDatePicker.date
        //            newTransaction.boughtCurrency =  selectedCoin?.symbol
        //            newTransaction.convertedCurrency = AddTransactionViewController.tradingPairCoinSymbol
        //            newTransaction.logo = selectedCoin?.imageData
        //
        //            PersistanceManager.updateHoldingsWithNewTransaction(transaction: newTransaction)
        //        }
        
        let newTransaction = createTransactionModel()
        PersistanceManager.updateHoldingsWithNewTransaction(transaction: newTransaction)
    }
    
    private func createTransactionModel() -> Transaction {
        let transaction = Transaction(context: PersistanceManager.context)
        transaction.type = transactionType
        return transaction
    }
}
