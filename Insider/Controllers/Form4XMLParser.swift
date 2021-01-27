//
//  Form4XMLParser.swift
//  Insider
//
//  Created by John Baer on 1/23/21.
//

import UIKit
import SwiftyXMLParser

class Form4XMLParser: NSObject {
    
    class func parseXML(_ xmlURL: String, completionHandler: @escaping (TradeInformation?, Error?) -> TradeInformation?) {
        let url = URL(string: xmlURL)!
                
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            let xmlString = String(decoding: data, as: UTF8.self)
            let xml = try! XML.parse(xmlString)
            
            print(xmlString)
            
            // access xml element
            let ticker = String(xml["ownershipDocument", "issuer", "issuerTradingSymbol"].text ?? "")
            let companyName = String(xml["ownershipDocument", "issuer", "issuerName"].text ?? "")
            let insiderName = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerId", "rptOwnerName"].text ?? "")
            let isDirector = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isDirector"].text ?? "0")
            let isOfficer = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isOfficer"].text ?? "0")
            let isTenPercentOwner = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isTenPercentOwner"].text ?? "0")
            let officerTitle = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "officerTitle"].text ?? "")
            
            // TODO: Right now I can't think of a clean way to condense multiple trades in one form. So I will just parse
            //       the first trade only
            
            //A for acquiration, D for disposal
            let tradeType = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "transactionAmounts", "transactionAcquiredDisposedCode", "value"].text ?? "")
            let tradePrice = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "transactionAmounts", "transactionPricePerShare", "value"].text ?? "")
            let tradeQty = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "transactionAmounts", "transactionShares", "value"].text ?? "")
            let stockCountOwnedAfter = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "postTransactionAmounts", "sharesOwnedFollowingTransaction", "value"].text ?? "")
            
            var valueOfStockInDollars = "---"
            if let tradeQtyD = tradeQty.double{
                if let tradePriceD = tradePrice.double{
                    valueOfStockInDollars = String(tradeQtyD * tradePriceD)
                }
            }
            
            // Calculate percentage change: Formula is tradeQty/(stockCountOwnedAfter-tradeQty) X 100
            var percentageChange = "---"
            if let tradeQtyD = tradeQty.double{
                if let stockCountOwnedAfterD = stockCountOwnedAfter.double{
                    let percentChangeD = tradeQtyD / (stockCountOwnedAfterD - tradeQtyD) * 100
                    percentageChange = String(format: "%.2f", percentChangeD)
                }
            }
            
            if valueOfStockInDollars != "---"{
                let doubleDollars = Double(valueOfStockInDollars)
                valueOfStockInDollars = String(format: "%.2f", doubleDollars!)
            }
            var companyPositions: [String] = []
            if isDirector == "1" { companyPositions.append("Director") }
            if isOfficer == "1" { companyPositions.append("Officer") }
            if isTenPercentOwner == "1" { companyPositions.append("10% Owner") }
//            TODO: get the other's name   if isOther == "1" { companyPositions.append("Director") }
            if officerTitle != "" { companyPositions.append(officerTitle) }
            
            let tradeDetails = TradeInformation.init(ticker: ticker, companyName: companyName, insiderName: insiderName, companyPosition: companyPositions, tradeType: tradeType, tradePrice: tradePrice, tradeQty: tradeQty, stockCountOwnedAfter: stockCountOwnedAfter, valueOfStockInDollars: valueOfStockInDollars, stockCountPercentChange: percentageChange)
                        
            completionHandler(tradeDetails, nil)
        }
        task.resume()
    }
}


extension StringProtocol {
    var double: Double? { Double(self) }
    var float: Float? { Float(self) }
    var integer: Int? { Int(self) }
}
