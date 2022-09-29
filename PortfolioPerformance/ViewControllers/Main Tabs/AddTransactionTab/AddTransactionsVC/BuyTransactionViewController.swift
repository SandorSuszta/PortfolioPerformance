//
//  BuyTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 22/02/2022.
//

import UIKit
import CoreData

class BuyTransactionViewController: UIViewController {

    @IBOutlet weak var buyPriceTextField: UITextField!
    @IBOutlet weak var buyAmmountTextField: UITextField!
    @IBOutlet weak var priceTypeSegmentedConrol: UISegmentedControl!
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var buyDatePicker: UIDatePicker!
    
    @IBAction func addTransactionPressed(_ sender: Any) {
        saveBuyTransaction()
        
        //Back to root
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTransactionButton.layer.cornerRadius = 10
        buyPriceTextField.delegate = self
        buyAmmountTextField.delegate = self
        
        configureTextFields()
    }
    
    func configureTextFields() {
        buyPriceTextField.keyboardType = .numberPad
        buyPriceTextField.borderStyle = .none
        buyPriceTextField.becomeFirstResponder()
        
        buyAmmountTextField.returnKeyType = .done
        buyAmmountTextField.borderStyle = .none
        buyAmmountTextField.keyboardType = .asciiCapableNumberPad
    }
    
    func saveBuyTransaction() {
        let newTransaction = Transaction(context: WatchlistManager.context)
        let selectedCoin = AddTransactionViewController.selectedCoin
        
        newTransaction.type = "buy"
        newTransaction.ammount = Double(buyAmmountTextField.text!) ?? 0
        newTransaction.price = Double(buyPriceTextField.text!) ?? 0
        newTransaction.dateAndTime = buyDatePicker.date
        newTransaction.boughtCurrency =  selectedCoin?.symbol
        newTransaction.convertedCurrency = AddTransactionViewController.tradingPairCoinSymbol
        newTransaction.logo = selectedCoin?.imageData
        
        WatchlistManager.updateHoldingsWithNewTransaction(transaction: newTransaction)
    }
    
//    func updateHoldings() {
//        let selectedCoin = AddTransactionViewController.selectedCoin
//        let holdings = PersistanceManager.loadHoldings()
//        if let holdingToUpdate = holdings.first(where: {
//            $0.symbol == selectedCoin?.symbol
//        }) {
//            holdingToUpdate.ammount += Double(buyAmmountTextField.text!) ?? 0
//            PersistanceManager.saveUpdates()
//        } else {
//            let newHolding = HoldingModel(context: PersistanceManager.context)
//            newHolding.symbol = selectedCoin?.symbol
//            newHolding.ammount = Double(buyAmmountTextField.text!) ?? 0
//            PersistanceManager.saveUpdates()
//        }
//    }
}


    // MARK: - Text field delegate methods
    extension BuyTransactionViewController: UITextFieldDelegate {
        
        
}
