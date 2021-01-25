//
//  MainTVC.swift
//  Insider
//
//  Created by John Baer on 1/25/21.
//

import UIKit

class MainTVC: UITableViewController {

    let tradeInformations: [TradeInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Grab like 20 datas from SEC-API
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeInformations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockDisplayTVCell", for: indexPath) as! StockDisplayTVCell
        cell.populate(tradeInformations[indexPath.row])
        return cell
    }
}
