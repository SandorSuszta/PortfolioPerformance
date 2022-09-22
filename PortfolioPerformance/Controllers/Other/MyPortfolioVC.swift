//
//  PortfolioViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 23/05/2022.
//

import UIKit

class MyPortfolioViewController: UIViewController {
    
    var holdingModels = PersistanceManager.loadHoldings().sorted {
        $0.ammount < $1.ammount
    }

    var holdingPerfomanceModels: [HoldingPerfomanceModel] = []

    private let portfolioTableView: UITableView = {
        let table = UITableView()
        table.register(
            HoldingsTableViewCell.self,
            forCellReuseIdentifier: HoldingsTableViewCell.identifier
        )
        table.layer.cornerRadius = 15
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        portfolioTableView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.bottom + 20,
            width: view.width - 40,
            height: view.bottom
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        view.addSubview(portfolioTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        holdingModels = PersistanceManager.loadHoldings()
        updateHoldingPerfomanceModels(from: holdingModels)
        holdingPerfomanceModels.sort {
            $0.holdingValue > $1.holdingValue
        }
        portfolioTableView.reloadData()
    }

}

extension MyPortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        holdingPerfomanceModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HoldingsTableViewCell.identifier,
            for: indexPath
        ) as? HoldingsTableViewCell else {
            fatalError()
        }
        
        cell.configure(
            with: HoldingsTableViewCellViewModel(
                holdingPerfomanceModel: holdingPerfomanceModels[indexPath.row],
                portfolioValue: holdingPerfomanceModels.reduce(0){ $0 + $1.holdingValue }
            )
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HoldingsTableViewCell.prefferedHeight
    }
    
    private func updateHoldingPerfomanceModels (from holdingModels: [HoldingModel]) {
        
        holdingPerfomanceModels = []
        
        holdingModels.forEach { holdingModel in
         
            guard let coinModel = AllMarketData.shared.allCoinsArray.first(where: {
                $0.symbol == holdingModel.symbol
            }) else { fatalError() }
            
            let holdingPerfomanceModel = HoldingPerfomanceModel(
                holdingModel: holdingModel, coinModel: coinModel)
            
           holdingPerfomanceModels.append(holdingPerfomanceModel)
        }
    }
}
