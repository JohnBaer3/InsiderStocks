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
    
    
    @IBAction func buttonClick(_ sender: Any) {
        print(tradeInformations)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Grab like 20 datas from SEC-API
        sec.callAPI(){ [weak self] success, result, httpResponseStatusCode in
            switch success{
            case true:
                self!.tradeInformations = result
                print(self!.tradeInformations)
                print(result)
                DispatchQueue.main.async {
                    self!.tableView?.reloadData()
                }
            default:
                print("oops! a fucky wucky!!")
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeInformations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockDisplayTVCell", for: indexPath) as! StockDisplayTVCell
        cell.populate(tradeInformations[indexPath.row])
        print("hmm")
        return cell
    }
}
