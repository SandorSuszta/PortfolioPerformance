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
    }
    
    func saveBuyTransaction() {
        let newTransaction = Transaction(context: PersistanceManager.context)
        let selectedCoin = AddTransactionViewController.selectedCoin
        
        newTransaction.type = "buy"
        newTransaction.ammount = Double(buyAmmountTextField.text!) ?? 0
        newTransaction.price = Double(buyPriceTextField.text!) ?? 0
        newTransaction.dateAndTime = buyDatePicker.date
        newTransaction.boughtCurrency =  selectedCoin?.symbol.uppercased()
        newTransaction.soldCurrency = AddTransactionViewController.tradingPairCoinSymbol.uppercased()
        newTransaction.logoData = selectedCoin?.imageData
        
        PersistanceManager.saveTransaction()
    }

}
