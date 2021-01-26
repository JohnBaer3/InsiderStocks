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
    let date = Date()
    let calendar = Calendar.current
    
    @IBAction func recentClicked(_ sender: Any) {
        changeFilter(-1)
        populateTable()
    }
    @IBAction func DClicked(_ sender: Any) {
        changeFilter(1)
        populateTable()
    }
    @IBAction func WClicked(_ sender: Any) {
        changeFilter(7)
        populateTable()
    }
    @IBAction func MClicked(_ sender: Any) {
        changeFilter(30)
        populateTable()
    }
    @IBAction func YClicked(_ sender: Any) {
        changeFilter(360)
        populateTable()
    }
    
    func changeFilter(_ daysToChangeBy: Int){
        if daysToChangeBy == -1{
            sec.filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\")"
        }else{
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            sec.filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[\(String(year))-\(String(month))-\(String(day-daysToChangeBy))TO\(String(year))-\(String(month))-\(String(day))]"
        }
    }
    
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
