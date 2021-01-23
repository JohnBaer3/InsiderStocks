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
        
        AF.request(API, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
          switch response.result {
                        case .success:
                            print(response)

                            break
                        case .failure(let error):

                            print(error)
                        }
        }

    }
}




