//
//  ConvertTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 20/03/2022.
//

import Foundation
import UIKit

class ConvertTransactionViewController: UIViewController {
    
    @IBOutlet weak var convertPriceTextField: UITextField!
    
    @IBOutlet weak var convertAmmountTextField: UITextField!
    
    @IBOutlet weak var convertPriceTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // TODO: get price with date change
    
    @IBAction func dateChanged(_ sender: Any) {
        getPriceOnTransactionDate()
    }
    
    @IBAction func addConvertTransactionClicked(_ sender: Any) {
        
        saveConvertTransaction()
        
        //Return to addCoin screen
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getPriceOnTransactionDate()
        addTransactionButton.layer.cornerRadius = 10
        
    }
    
    private let selectedCoin = AddTransactionViewController.selectedCoin
    var priceThen = 0.0
    
    func saveConvertTransaction() {
        
        let transaction = Transaction(context: PersistanceManager.context)
        
        transaction.type = "convert"
        transaction.boughtCurrency = AddTransactionViewController.selectedCoin?.symbol.uppercased()
        transaction.convertedCurrency = AddTransactionViewController.tradingPairCoinSymbol.uppercased()
        transaction.dateAndTime = datePicker.date
        transaction.price = Double(convertPriceTextField.text!) ?? 0.0
        transaction.ammount = Double(convertAmmountTextField.text!) ?? 0.0
        transaction.priceThen = priceThen
        transaction.convertedCoinWorthThen = transaction.ammount * transaction.priceThen
        transaction.logo = selectedCoin?.imageData
        
        PersistanceManager.saveTransaction()
    }
    
    func getPriceOnTransactionDate() {
        APICaller.shared.getPriceOnGivenDate(
            for: selectedCoin?.id ?? "",
            on: datePicker.date.stringForAPI()
        ) { result in
            switch result {
            case .success(let price):
                self.priceThen = price
            case .failure(let error):
                print(error)
            }
        }
    }
}
