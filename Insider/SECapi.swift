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
    let start = 3
    let end = 5
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
                    let responseD = value as! NSDictionary
                    
                    let xmlPath = (((responseD["filings"] as! NSArray)[0]) as! NSDictionary)["linkToFilingDetails"]!
                    let xmlURL = xmlPath as! String
                    
                    print(xmlURL)
                    
                    //What we need is... get the contents of the xmlURL
                    Form4XMLParser.requestSong(xmlURL) { song, artist, error in
                        guard let song = song, let artist = artist, error == nil else {
                            print(error ?? "Unknown error")
                            return
                        }
                        
                        print("Song:", song)
//                        print("Artist:", artist)
                    }
                    
                    
                    
                    
                    //Make it parseable somehow - convert it into a giant json tree?
                    
                    
                    
                    //Then parse it

                    
                    
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
