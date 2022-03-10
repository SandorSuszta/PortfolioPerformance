//
//  BuyTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 22/02/2022.
//

import UIKit

class BuyTransactionViewController: UIViewController {

    @IBOutlet weak var buyPriceTextField: UITextField!
    @IBOutlet weak var buyAmmountTextField: UITextField!
    @IBOutlet weak var priceTypeSegmentedConrol: UISegmentedControl!
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var buyDatePicker: UIDatePicker!
    
    @IBAction func addTransactionPressed(_ sender: Any) {
        if let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addCoin") {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTransactionButton.layer.cornerRadius = 10
    }
    


}
