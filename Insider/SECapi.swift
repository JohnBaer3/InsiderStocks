//
//  SECapi.swift
//  Insider
//
//  Created by John Baer on 1/20/21.
//

import Foundation
import Starscream
import Alamofire


class SECapi{
    let payload : Dictionary<String, Any> = [
        "query": [
            "query_string": [
                "query": "cik:320193 AND filedAt:{2016-01-01 TO 2016-12-31} AND formType:\"10-Q\""
            ]
        ],
        "from": "0",
        "size": "10",
        "sort": [
            ["filedAt":
                ["order": "desc"]
            ]
        ]
    ]

    
    let TOKEN = "6e66d2987314d70b3caa7d2d5c5ec2b294223ff84de46592315857264bf7d621"
    let API: URL
    
    let headers = [
        "Content-Type": "application/json; charset=utf-8",
    ]
    

    
    public var checker = "bla"
    
    init(){
        self.API = URL(string: "https://api.sec-api.io?token=" + TOKEN)!
    }
    
    
    
    func callAPI(_ completionHandler:@escaping (_ success:Bool,_ response:String,_ httpResponseStatusCode:Int) -> Void){
        let request = NSMutableURLRequest(url: API,
                                          cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        //Convert postData to a JSONObject?
        if let data = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted),
           let jsonString = String(data: data, encoding: .utf8) {
               request.httpBody = jsonString.data(using: .utf8)
//            print(jsonString.data(using: .utf8))
        }
        
        

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {

                DispatchQueue.main.async(execute: {

                    if let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? Dictionary<String,AnyObject>
                    {
                        let status = json["status"] as? Int;
                        if(status == 1)
                        {
                            print("SUCCESS....")
                            print(json)
                            if let CartID = json["CartID"] as? Int {
                                DispatchQueue.main.async(execute: {

                                    print("INSIDE CATEGORIES")
                                    print("CartID:\(CartID)")
//                                        self.addtocartdata.append(Addtocartmodel(json:json))
                                })
                            }
                        }
                    }
                })
                print("hmm")
            }
            print("here")
        })
        print("end")

    }
}




