//
//  MainTVC.swift
//  Insider
//
//  Created by John Baer on 1/25/21.
//

import UIKit

class MainTVC: UITableViewController {
    
    let sec = SECapi()
    var tradeInformations: [TradeInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        populateTable()
    }
    
    
    func populateTable(){
        sec.callAPI(){ [weak self] success, result, httpResponseStatusCode in
            switch success{
            case true:
                self!.tradeInformations = result
                DispatchQueue.main.async {
                    self!.tableView?.reloadData()
                }
            default:
                print("oops! a fucky wucky!!")
            }
        }
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
