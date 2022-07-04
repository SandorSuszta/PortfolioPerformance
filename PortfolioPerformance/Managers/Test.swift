//
//  ViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 15/06/2022.
//

import UIKit

class TestVC: UIViewController {
    
    let circle = CircularProgressBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.addSublayer(circle)
        circle.frame = CGRect(x: view.width / 2 , y: view.height/2, width: 100, height: 100)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
