//
//  SECapi.swift
//  Insider
//
//  Created by John Baer on 1/20/21.
//

import Foundation
import Starscream

struct payload: Encodable{
    enum CodingKeys: String, CodingKey {
        case query
        case from
        case size
        case sort
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(["query_string" : ["query": "cik:320193 AND filedAt:{2016-01-01 TO 2016-12-31} AND formType:\"10-Q\""]], forKey: .query)
        try container.encode("0", forKey: .from)
        try container.encode("10", forKey: .size)
        try container.encode(["filledAt": ["order": "desc"]], forKey: .sort)
    }
}


class SECapi{
    let TOKEN = "6e66d2987314d70b3caa7d2d5c5ec2b294223ff84de46592315857264bf7d621"
    let API: URL
    
    
    init(){
        self.API = URL(string: "https://api.sec-api.io?token=" + TOKEN)!
    }
    
    func callAPI(){
        var request = URLRequest(url: API)
        let encoder = JSONEncoder()
        let payloader = payload()
        if let jsonData = try? encoder.encode(payloader) {
            if String(data: jsonData, encoding: .utf8) != nil {

                //Add headers to the request
                request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.addValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")

                print("hm")
                request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    guard let data = data else { return }
                    print(String(data: data, encoding: .utf8)!)
                    print(response)
                    print(error)
                }
            }
        }
        
        task.resume()

        print("hmm")
        
    }
}




