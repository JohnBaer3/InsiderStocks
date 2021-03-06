//
//  IndividualStockVC.swift
//  Insider
//
//  Created by John Baer on 1/26/21.
//

import UIKit
import Charts
import TinyConstraints

class IndividualStockVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var companyTicker: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var openTradePrice: UILabel!
    @IBOutlet weak var tradeHighPrice: UILabel!
    @IBOutlet weak var stockChartView: UIView!
    @IBOutlet weak var insiderName: UILabel!
    @IBOutlet weak var insiderPositions: UILabel!
    @IBOutlet weak var totalStockOwnedPrice: UILabel!
    @IBOutlet weak var totalStockCountOwned: UILabel!
    
    
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    let alphaVantage = AlphaVantageAPI()
    var tradeInfo: TradeInformation? = nil
//        let tempTradeInfo: TradeInformation = TradeInformation(ticker: Optional("PPL"), companyName: Optional("PPL Corp"), insiderName: Optional("Bergstein Joseph P Jr"), companyPosition: Optional(["Officer", "SVP and CFO"]), tradeType: Optional("A"), tradePrice: Optional("28.11"), tradeQty: Optional("1372"), stockCountOwnedAfter: Optional("14270.386"), valueOfStockInDollars: Optional("38566.92"), stockCountPercentChange: Optional("10.64"))


    lazy var stockChart: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tradeInfo = tempTradeInfo
        
        makeChart()
        populateScreen(tradeInfo)
        populateTable()
    }
    
    func makeChart(){
        stockChartView.addSubview(stockChart)
        stockChart.centerInSuperview()
        stockChart.width(to: stockChartView)
        stockChart.height(to: stockChartView)
    }
    
    func populateTable(){
        alphaVantage.ticker = String((tradeInfo?.ticker)!)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.alphaVantage.grabData(){ error, open, high, chartDatas in
                if error == nil{
                    DispatchQueue.main.async {
                        let set1 = LineChartDataSet(entries: chartDatas, label: "yAxis")
                        let data = LineChartData(dataSet: set1)
                        self?.stockChart.data = data
                        self?.openTradePrice.text = String(open)
                        self?.tradeHighPrice.text = String(high)
                    }
                }else{
                    print(error)
                }
            }
        }
    }
    
    
    func populateScreen(_ tradeInfo: TradeInformation?){
        companyTicker.text = tradeInfo?.ticker ?? ""
        companyName.text = tradeInfo?.companyName ?? ""
        insiderName.text = tradeInfo?.insiderName ?? ""
        insiderPositions.text = companyPositions(tradeInfo?.companyPosition)
        totalStockOwnedPrice.text = tradeInfo?.valueOfStockInDollars ?? ""
        totalStockCountOwned.text = tradeInfo?.stockCountOwnedAfter ?? ""
        
        secondTitleLabel.text = "Previous \(tradeInfo?.ticker ?? "") Trades"
    }
    
    func companyPositions(_ positions: [String]?) -> String{
        var companyPositionText = ""
        for position in positions ?? [""]{
            companyPositionText += position
            companyPositionText += ", "
        }
        if companyPositionText.count > 3{
            companyPositionText = String(companyPositionText.dropLast(2))
        }
        return companyPositionText
    }


}
