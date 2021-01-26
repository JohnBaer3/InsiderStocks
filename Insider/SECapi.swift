//
//  SECapi.swift
//  Insider
//
//  Created by John Baer on 1/20/21.
//
import Foundation
import Starscream
import Alamofire

class SECapi: NSObject {
    let filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[2019-07-01 TO 2019-08-01]"
    let payload : Dictionary<String, Any>
    let start = 3
    let end = 5
    let sort = [["filedAt": ["order": "desc"]]]
    let TOKEN = "8d1ba108179545e960eabcf12a5ce41dad07cdaa85c0ee6993323f52f4ee838a"
    let API: URL
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json; charset=utf-8",
//        "Content-Length": "20000"
    ]
    

    override init(){
        self.API = URL(string: "https://api.sec-api.io?token=" + TOKEN)!
        
        self.payload = [
            "query": [
                "query_string": ["query": filter]
            ],
            "from": start,
            "size": end,
            "sort": sort
        ]
    }
    
    
    func getXML(_ xmlURL: String, _ completionHandler:@escaping (_ tradeDetails: TradeInformation?) -> Void){
        Form4XMLParser.parseXML(xmlURL) { tradeDetails, error in
            if let tradeDetails = tradeDetails, error == nil {
                 completionHandler(tradeDetails)
            }else{
                print(error ?? "Unknown error")
            }
            return nil
        }
    }
    
    
    
    func callAPI(_ completion:@escaping (_ success:Bool,_ response:[TradeInformation],_ httpResponseStatusCode:Int) -> Void){
        AF.request(API, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
            switch response.result {
            case .success(let value):
                let responseD = value as! NSDictionary
                let responseDArr = responseD["filings"] as! NSArray
                var tradeInformations: [TradeInformation] = []
                var counter = responseDArr.count
                
                for jsonIter in responseDArr{
                    let jsonDictionary = jsonIter as! NSDictionary
                    let websiteBlock = jsonDictionary["documentFormatFiles"] as! NSArray
                    let xmlURL = (websiteBlock[1] as! NSDictionary)["documentUrl"] as! String
                    self.getXML(xmlURL){ (tradeInfo) in
                        if tradeInfo != nil{
                            tradeInformations.append(tradeInfo!)
                            print(tradeInformations)
                        }
                        counter -= 1
                        if counter == 0{
                            completion(true, tradeInformations, 0)
                        }
                    }
                }                
   
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
