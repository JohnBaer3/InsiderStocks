//
//  MainTVC.swift
//  Insider
//
//  Created by John Baer on 1/25/21.
//

import UIKit

class MainTVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topNavBar: UIImageView!
    @IBOutlet weak var recentButton: UIButton!
    @IBOutlet weak var DButton: UIButton!
    @IBOutlet weak var WButton: UIButton!
    @IBOutlet weak var MButton: UIButton!
    @IBOutlet weak var YButton: UIButton!
    
    let sec = SECapi()
    var tradeInformations: [TradeInformation] = []
    
    
    var indicator = UIActivityIndicatorView()
    private var isLoading = false{
        didSet{
            if isLoading{
                activityIndicator()
                indicator.startAnimating()
                indicator.backgroundColor = .white
            }else{
                indicator.stopAnimating()
                indicator.hidesWhenStopped = true
            }
        }
    }
    
    @IBAction func recentClicked(_ sender: Any) {
        animateSlider(recentButton.center.x)
        sec.changeFilter(-1)
        populateTable()
    }
    @IBAction func DClicked(_ sender: Any) {
        animateSlider(DButton.center.x)
        sec.changeFilter(1)
        populateTable()
    }
    @IBAction func WClicked(_ sender: Any) {
        animateSlider(WButton.center.x)
        sec.changeFilter(7)
        populateTable()
    }
    @IBAction func MClicked(_ sender: Any) {
        animateSlider(MButton.center.x)
        sec.changeFilter(30)
        populateTable()
    }
    @IBAction func YClicked(_ sender: Any) {
        animateSlider(YButton.center.x)
        sec.changeFilter(360)
        populateTable()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.searchBar.delegate = self
        populateTable()
    }
    
    
    func animateSlider(_ destinationX: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.topNavBar.center.x = destinationX
        }, completion: nil)
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    func populateTable(){
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self!.sec.callAPI(){ success, result, httpResponseStatusCode in
                switch success{
                case true:
                    self!.tradeInformations = result
                    DispatchQueue.main.async {
                        self!.tableView?.reloadData()
                        self!.isLoading = false
                    }
                default:
                    print("oops! a fucky wucky!!")
                }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tradeInfoForCell = tradeInformations[indexPath.row]
        let nextVC = IndividualStockVC()
        nextVC.tradeInfo = tradeInfoForCell
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}


extension MainTVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        sec.changeFilterToSearchTerm(searchBar.text ?? "")
        populateTable()
    }
}
