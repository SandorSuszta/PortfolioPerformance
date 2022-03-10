//
//  TransferTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 22/02/2022.
//

import UIKit

class TransferTransactionViewController: UIViewController {
    @IBOutlet weak var transferTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var transferAmmountTextField: UITextField!
    @IBOutlet weak var transferDatePicker: UIDatePicker!
    @IBOutlet weak var addTransactionButton: UIButton!
    
    @IBAction func addTransactionClicked(_ sender: Any) {
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTransactionButton.layer.cornerRadius = 10
        
    }
    

}
