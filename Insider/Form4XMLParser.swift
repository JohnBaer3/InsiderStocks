//
//  Form4XMLParser.swift
//  Insider
//
//  Created by John Baer on 1/23/21.
//

import UIKit
import SwiftyXMLParser

class Form4XMLParser: NSObject {
    
    class func requestSong(_ xmlURL: String, completionHandler: @escaping (String?, String?, Error?) -> Void) {
        let url = URL(string: xmlURL)!
        
        //open the xml -> get the data from
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
                return
            }
            let xmlString = String(decoding: data, as: UTF8.self)
            
            print(xmlString)
            
            let xml = try! XML.parse(xmlString)

            // access xml element
            let ticker = String(xml["ownershipDocument", "issuer", "issuerTradingSymbol"].text ?? "")
            let companyName = String(xml["ownershipDocument", "issuer", "issuerName"].text ?? "")
            let insiderName = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerId", "rptOwnerName"].text ?? "")
            let isDirector = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isDirector"].text ?? "0")
            let isOfficer = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isOfficer"].text ?? "0")
            let isTenPercentOwner = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isTenPercentOwner"].text ?? "0")
            let isOther = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "isOther"].text ?? "0")
            let officerTitle = String(xml["ownershipDocument", "reportingOwner", 0, "reportingOwnerRelationship", "officerTitle"].text ?? "")
            
            // TODO: Right now I can't think of a clean way to condense multiple trades in one form. So I will just parse
            //       the first trade only
            let tradeInfo = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "transactionAmounts", "transactionAcquiredDisposedCode", "value"].text ?? "--")
            let tradePrice = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "transactionAmounts", "transactionPricePerShare", "value"].text ?? "--")
            let tradeQty = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "transactionAmounts", "transactionShares", "value"].text ?? "")
            let stockCountOwnedAfter = String(xml["ownershipDocument", "nonDerivativeTable", "nonDerivativeTransaction", 0, "postTransactionAmounts", "sharesOwnedFollowingTransaction", "value"].text ?? "")
            var valueOfStockInDollars = String((Double(tradePrice) ?? 0) * (Double(tradeQty) ?? 0))
            if valueOfStockInDollars == "0.0"{
                valueOfStockInDollars = "--"
            }
            
            // TODO: Calculate percentage change: Formula is value/(tradeTotalAfter-value) X 100
//            let stockCountPercentChange = valueOfStockInDollars == "--" ?? "--" : (Double(valueOfStockInDollars) / ())
            
            print(ticker)
            print(companyName)
            print(insiderName)
            print(isDirector)
            print(isOfficer)
            print(isTenPercentOwner)
            print(isOther)
            print(officerTitle)
            print(tradeInfo)
            print(tradePrice) //fail
            print(tradeQty)
            print(stockCountOwnedAfter)
            print(valueOfStockInDollars) //fail
            
            
            completionHandler("delegate.song", "delegate.artist", nil)
        }
        task.resume()
    }
}
