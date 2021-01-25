//
//  Form4XMLParser.swift
//  Insider
//
//  Created by John Baer on 1/23/21.
//

import UIKit
import SwiftyXMLParser

class Form4XMLParser: NSObject {
//    var ticker: String?
//    var companyName: String?
//    var insiderName: String?
//    var companyPosition: [String]?
//    var tradeType: String?
//    var tradePrice: Int?
//    var tradeQty: Int?
//    var stockCountOwnedAfter: Int?
//    var valueOfStockInDollars: Int?
//    var stockCountPercentChange: Int?
    
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
            let isDirector = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerRelationship", "isDirector"].text ?? "0")
            let isOfficer = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerRelationship", "isOfficer"].text ?? "0")
            let isTenPercentOwner = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerRelationship", "isTenpercentOwner"].text ?? "0")
            let isOther = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerRelationship", "isOther"].text ?? "0")
            let officerTitle = String(xml["ownershipDocument", "reportingOwner", "reportingOwnerRelationship", "officerTitle"].text ?? "")
            
            // TODO: Right now I can't think of a clean way to condense multiple trades in one form. So I will just parse
            //       the first trade only
            for trade in xml["ownershipDocument", "nonDerivativeTable"]{
                
            }
            
            
            
            
            // access XML Text

//            if let text = xml["ResultSet", "Result", "Hit", 0, "Name"].text {
//                print(text)
//            }
            
            completionHandler("delegate.song", "delegate.artist", nil) //parser.parserError)
        }
        task.resume()
    }
}
