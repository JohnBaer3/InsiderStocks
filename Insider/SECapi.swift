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
    let filter = "formType:\"4\" AND formType:(NOT \"N-4\") AND formType:(NOT \"4/A\") AND filedAt:[2019-07-01 TO 2019-08-01]"
    
    let payload : Dictionary<String, Any>
    let start = 0
    let end = 10000
    let sort = [["filedAt": ["order": "desc"]]]
    let TOKEN = "6e66d2987314d70b3caa7d2d5c5ec2b294223ff84de46592315857264bf7d621"
    let API: URL
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json; charset=utf-8",
//        "Content-Length": "20000"
    ]
    

    init(){
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
    
    
    
    func callAPI(_ completionHandler:@escaping (_ success:Bool,_ response:String,_ httpResponseStatusCode:Int) -> Void){
        AF.request(API, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
        switch response.result {
            case .success(let value):
                do {
                    //Decode from .utf-8
//                    print(response.result)

                    print(value as! NSDictionary)
                    
//                    let responseD = response.result as! NSDictionary
//
//                    print(responseD)
//                    print(responseD["filings"])
                    
                    
                    
//                    let data1 =  try JSONSerialization.data(withJSONObject: response.result, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//
//                    let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//                    print(convertedString) // <-- here is ur string
                    
                    
                } catch let myJSONError {
                    print("oops! error")
                    print(myJSONError)
                }

                break
            case .failure(let error):

                print(error)
            }
        }
    }
}

//struct insiderData: Codable{
//    let name: String?
//    let avatarUrl: URL?
//    let repos: Int?
//
//    private enum CodingKeys: String, CodingKey{
//        case name
//        case avatarUrl = “avatar_url”
//        case repos = “public_repos”
//    }
//
//}
