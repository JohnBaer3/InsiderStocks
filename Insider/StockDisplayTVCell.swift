//
//  StockDisplayTVCell.swift
//  Insider
//
//  Created by John Baer on 1/25/21.
//

import UIKit

class StockDisplayTVCell: UITableViewCell {

    @IBOutlet weak var companyTicker: UILabel!
    @IBOutlet weak var stockTotalDollars: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var insiderName: UILabel!
    @IBOutlet weak var insiderPosition: UILabel!
    @IBOutlet weak var dollarChange: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    
    func populate(_ tradeInfo: TradeInformation){
        companyTicker.text = tradeInfo.ticker
        stockTotalDollars.text = tradeInfo.valueOfStockInDollars
        companyName.text = tradeInfo.companyName
        insiderName.text = tradeInfo.insiderName
        dollarChange.text = tradeInfo.tradeQty
        let companyPositionText = companyPositions(tradeInfo.companyPosition)
        insiderPosition.text = companyPositionText
        percentChange.text = "TBD"
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
