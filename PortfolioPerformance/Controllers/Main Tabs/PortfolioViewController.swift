//
//  PortfolioViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 23/05/2022.
//

import UIKit

class MyPortfolioViewController: UIViewController, UITableViewDelegate {
    
    private let portfolioTableView: UITableView = {
        let table = UITableView()
        table.register(
            HoldingsTableViewCell.self,
            forCellReuseIdentifier: HoldingsTableViewCell.identifier
        )
        table.layer.cornerRadius = 8
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        portfolioTableView.frame = view.bounds
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension MyPortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HoldingsTableViewCell.identifier,
            for: indexPath
        ) as? HoldingsTableViewCell else {
            fatalError()
        }
        return cell
    }
}
