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
    let date = Date()
    let calendar = Calendar.current
    
//    var filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[2021-01-01 TO 2021-01-24]"
    var filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\")"
    let payload : Dictionary<String, Any>
    let start = 0
    let end = 2
    let sort = [["filedAt": ["order": "desc"]]]
    let TOKEN = "fa240330da4e70f44f6a147121358f82e8e27d8d3d5c470edc6c77940300b6fa"
    let API: URL
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json; charset=utf-8",
    ]
    

    override init(){
        self.API = URL(string: "https://api.sec-api.io?token=" + TOKEN)!
        
        self.payload = [
            "query": ["query_string": ["query": filter]],
            "from": start,
            "size": end,
            "sort": sort
        ]
    }
    
    
    func changeFilter(_ daysToChangeBy: Int){
        if daysToChangeBy == -1{
            filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\")"
        }else{
            let day = calendar.component(.day, from: date)
            let stringDay: String = (String(day).count == 1) ? ("0" + String(day-1)) : String(day)
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
            
            filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[\(String(goToYear))-\(String(goToMonth))-\(String(goToDay))]"
            
//            filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[\(String(year))-\(stringMonth)-\(stringDay)TO\(String(goToYear))-\(String(goToMonth))-\(String(goToDay))]"
//            payload["query"]["query_string"]["query"] = filter
            
            //
        }
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
        
        print(self.filter)
        
        AF.request(API, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
            switch response.result {
            case .success(let value):
                //Catch this
                let responseD = value as! NSDictionary
                //Also catch this
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
