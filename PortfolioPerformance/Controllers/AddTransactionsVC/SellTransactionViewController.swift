//
//  SellTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 22/02/2022.
//

import UIKit
import CoreData

class SellTransactionViewController: UIViewController {
    
    @IBOutlet weak var sellPriceTextField: UITextField!
    
    @IBOutlet weak var sellAmmountTextField: UITextField!
    
    @IBOutlet weak var sellPriceTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func sellAllClicked(_ sender: Any) {

    }
    
    @IBAction func AddSellTransactionClicked(_ sender: Any) {
        
        saveSellTransaction()
        
        //Return to addCoin screen
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTransactionButton.layer.cornerRadius = 10
    }
    
    func saveSellTransaction() {
        let newTransaction = Transaction(context: PersistanceManager.context)
        let selectedCoin = AddTransactionViewController.selectedCoin
        
        newTransaction.type = "sell"
        newTransaction.ammount = Double(sellAmmountTextField.text!) ?? 0
        newTransaction.price = Double(sellPriceTextField.text!) ?? 0
        newTransaction.dateAndTime = datePicker.date
        newTransaction.boughtCurrency =  selectedCoin?.symbol.uppercased()
        newTransaction.soldCurrency = AddTransactionViewController.tradingPairCoinSymbol.uppercased()
        newTransaction.logoData = selectedCoin?.imageData
        
        PersistanceManager.saveTransaction()
    }
}
