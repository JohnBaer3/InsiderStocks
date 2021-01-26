//
//  MainTVC.swift
//  Insider
//
//  Created by John Baer on 1/25/21.
//

import UIKit

class MainTVC: UITableViewController {
    
    @IBOutlet weak var topNavBar: UIImageView!
    @IBOutlet weak var recentButton: UIButton!
    @IBOutlet weak var DButton: UIButton!
    @IBOutlet weak var WButton: UIButton!
    @IBOutlet weak var MButton: UIButton!
    @IBOutlet weak var YButton: UIButton!
    
    let sec = SECapi()
    var tradeInformations: [TradeInformation] = []
    let date = Date()
    let calendar = Calendar.current
    
    @IBAction func recentClicked(_ sender: Any) {
        animateSlider(recentButton.center.x)
        changeFilterAndRepopulate(-1)
    }
    @IBAction func DClicked(_ sender: Any) {
        animateSlider(DButton.center.x)
        changeFilterAndRepopulate(1)
    }
    @IBAction func WClicked(_ sender: Any) {
        animateSlider(WButton.center.x)
        changeFilterAndRepopulate(7)
    }
    @IBAction func MClicked(_ sender: Any) {
        animateSlider(MButton.center.x)
        changeFilterAndRepopulate(30)
    }
    @IBAction func YClicked(_ sender: Any) {
        animateSlider(YButton.center.x)
        changeFilterAndRepopulate(360)
    }
    
    func animateSlider(_ destinationX: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.topNavBar.center.x = destinationX
        }, completion: nil)
    }
    
    func changeFilterAndRepopulate(_ daysToChangeBy: Int){
        if daysToChangeBy == -1{
            sec.filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\")"
        }else{
            let day = calendar.component(.day, from: date)
            let stringDay: String = (String(day).count == 1) ? ("0" + String(day)) : String(day)
            let month = calendar.component(.month, from: date)
            let stringMonth: String = (String(month).count == 1) ? ("0" + String(month)) : String(month)
            let year = calendar.component(.year, from: date)
            
            var goToDay = 0
            var goToMonth = 0
            var goToYear = 0
            if day - daysToChangeBy < 1{
                goToMonth = month - 1
                if goToMonth < 1{
                    goToYear = year - 1
                }
                goToDay = day % 31
            }
            
            sec.filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[\(String(goToYear))-\(String(goToMonth))-\(String(goToDay))TO\(String(year))-\(stringMonth)-\(stringDay)]"
        }
        populateTable()
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
                self!.tradeInformations = []
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
