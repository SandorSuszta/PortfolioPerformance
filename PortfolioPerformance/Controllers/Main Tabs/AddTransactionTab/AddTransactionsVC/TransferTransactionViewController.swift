//
//  TransferTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 22/02/2022.
//

import UIKit

class TransferTransactionViewController: UIViewController {


    @IBOutlet weak var transferAmmountTextField: UITextField!
    @IBOutlet weak var transferDatePicker: UIDatePicker!
    @IBOutlet weak var addTransactionButton: UIButton!
    
    private var transferType = "Staking"
    
    @IBAction func transferTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transferType = "Staking"
        case 1:
            transferType = "Airdrop"
        case 2:
            transferType = "Other"
        default:
            return
        }
    }
    
    @IBAction func addTransactionClicked(_ sender: Any) {
        saveTransferTransaction()
     
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTransactionButton.layer.cornerRadius = 10
        
    }
    
    func saveTransferTransaction() {
        let newTransaction = Transaction(context: PersistanceManager.context)
        let selectedCoin = AddTransactionViewController.selectedCoin
        
        newTransaction.type = "transfer"
        newTransaction.ammount = Double(transferAmmountTextField.text!) ?? 0
        newTransaction.dateAndTime = transferDatePicker.date
        newTransaction.boughtCurrency =  selectedCoin?.symbol.uppercased()
        newTransaction.logo = selectedCoin?.imageData
        newTransaction.transferType = transferType
        
        PersistanceManager.saveUpdates()
    }
}
