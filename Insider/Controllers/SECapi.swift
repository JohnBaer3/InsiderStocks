//
//  SECapi.swift
//  Insider
//
//  Created by John Baer on 1/20/21.
//
import Foundation
import Alamofire

class SECapi: NSObject {
    let date = Date()
    let calendar = Calendar.current
    
//    var filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[2021-01-01 TO 2021-01-24]"
    var filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\")"
    var payload : Dictionary<String, Any>
    let start = 0
    let end = 20
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
            updatePayload(filter)
        }else{
            let day = calendar.component(.day, from: date) - 1
            let stringDay: String = (String(day).count == 1) ? ("0" + String(day)) : String(day)
            let month = calendar.component(.month, from: date)
            let stringMonth: String = (String(month).count == 1) ? ("0" + String(month)) : String(month)
            let year = calendar.component(.year, from: date)
            
            var goToDay = day - daysToChangeBy
            var goToMonth = month
            var goToYear = year
            if day < 1{
                goToMonth = month - 1
                if goToMonth < 1{
                    goToMonth = 12
                    goToYear = year - 1
                }
                goToDay = day % 31
            }
            let stringGotoDay: String = (String(goToDay).count == 1) ? ("0" + String(goToDay)) : String(goToDay)
            let stringGotoMonth: String = (String(goToMonth).count == 1) ? ("0" + String(goToMonth)) : String(goToMonth)
            
            filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[\(String(goToYear))-\(stringGotoMonth)-\(stringGotoDay) TO \(String(year))-\(stringMonth)-\(stringDay)]"
            updatePayload(filter)
        }
    }
    
    func changeFilterToSearchTerm(_ searchTerm: String){
        let filterTerm: String = "ticker:\(searchTerm) AND formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\")"
        updatePayload(filterTerm)
    }
    
    func updatePayload(_ newFilter: String){
        self.payload = [
            "query": ["query_string": ["query": newFilter]],
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
        AF.request(API, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self]
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
                    self?.getXML(xmlURL){ (tradeInfo) in
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
