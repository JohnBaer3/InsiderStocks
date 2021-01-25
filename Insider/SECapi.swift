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
    
    func getXML(){
        let xmlURL = "https://www.sec.gov/Archives/edgar/data/911614/000120919119044127/doc4.xml"
        
        Form4XMLParser.requestSong(xmlURL) { song, artist, error in
            guard let song = song, let artist = artist, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            print("Song:", song)
//                        print("Artist:", artist)
        }
    }
    
    
    
    func callAPI(_ completionHandler:@escaping (_ success:Bool,_ response:String,_ httpResponseStatusCode:Int) -> Void){
        AF.request(API, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
        switch response.result {
            case .success(let value):
                do {
                    //Decode from .utf-8
                    let responseD = value as! NSDictionary
                                        
                    let jsonDictionary = (((responseD["filings"] as! NSArray)[0]) as! NSDictionary)
                    let websiteBlock = jsonDictionary["documentFormatFiles"] as! NSArray
                    let xmlURL = (websiteBlock[1] as! NSDictionary)["documentUrl"] as! String
                                        
                    print(xmlURL)
                    
//                    //What we need is... get the contents of the xmlURL
//                    //Then parse it
//                    //converting into NSData
//                    var data: Data? = theXML.data(using: .utf8)
//                    //initiate  NSXMLParser with this data
//                    var parser: XMLParser? = XMLParser(data: data ?? Data())
//                    //setting delegate
//                    parser?.delegate = self
//                    //call the method to parse
//                    var result: Bool? = parser?.parse()
//                    parser?.shouldResolveExternalEntities = true
                    
                    
                    
                    
                    
                    
                    
                    
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


extension SECapi: XMLParserDelegate{
    
}
