//
//  SellTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 22/02/2022.
//

import UIKit

class SellTransactionViewController: UIViewController {
    
    @IBOutlet weak var sellPriceTextField: UITextField!
    
    @IBOutlet weak var sellAmmountTextField: UITextField!
    
    @IBOutlet weak var sellPriceTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    
    @IBAction func sellAllClicked(_ sender: Any) {

    }
    
    @IBAction func AddSellTransactionClicked(_ sender: Any) {
        
        let newTransaction = Transaction(context: PersistanceManager.context)
        
       
        if let sellPrice = sellPriceTextField.text,
           let sellAmmount = sellAmmountTextField.text {
            newTransaction.type = "sell"
            newTransaction.ammount = Double(sellAmmount) ?? 0
            newTransaction.sellPrice = Double(sellPrice) ?? 0
            
            PersistanceManager.saveTransaction()
            
        }
      
        
        
        //Return to addCoin screen
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTransactionButton.layer.cornerRadius = 10
    }
    

}
