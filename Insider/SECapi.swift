//
//  SECapi.swift
//  Insider
//
//  Created by John Baer on 1/20/21.
//

import Foundation
import Starscream

let payload: [String: Any] = [
    "query": ["query_string": [ "query": "cik:320193 AND filedAt:{2016-01-01 TO 2016-12-31} AND formType:\"10-Q\"" ]],
    "from": "0",
    "size": "10",
    "sort": [["filedAt": ["order": "desc"]]]
]



class SECapi{
    let TOKEN = "6e66d2987314d70b3caa7d2d5c5ec2b294223ff84de46592315857264bf7d621"
    let API: URL
    
    public var checker = "bla"
    
    init(){
        self.API = URL(string: "https://api.sec-api.io?token=" + TOKEN)!
    }
    
    func callAPI(_ completionHandler:@escaping (_ success:Bool,_ response:String,_ httpResponseStatusCode:Int) -> Void){
        var request = URLRequest(url: API)

//        let DicObject: NSMutableDictionary = NSMutableDictionary()
//              DicObject.setValue("cf", forKey: "a")
//              DicObject.setValue("", forKey: "scs")
//              DicObject.setValue("Uploads/" + nameOfFile, forKey:"p")

        
        
        
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            if let encoded = String(data: jsonData, encoding: .utf8){
                //Add headers to the request
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                
                
                //This has to be bytes                
                if let data = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                       request.httpBody = jsonString.data(using: .utf8)
                }
                
                
                print("top of the function")
                let task = URLSession.shared.dataTask(with: request) {(datar, response, error) in
                    guard let data = datar else { return }
                    print(String(data: data, encoding: .utf8)!)
                    print("here ", response)
                    print("here ", error)
                    let responseString = String(data: datar!, encoding: .utf8)
                    completionHandler(true, responseString ?? "hmmmm", 2)
                    self.checker = responseString ?? "ble" + " bla "
                }
                completionHandler(false, "error", 0)
            }
            print("out of the call")
        }catch{
            print("json conversion failed")
        }
        print("Reached end of function")
        
    }
}




