//
//  AlphaVantageAPI.swift
//  Insider
//
//  Created by John Baer on 1/27/21.
//

import Foundation

class AlphaVantageAPI: NSObject {
    
    let session = URLSession.shared

    let headers = [
        "x-rapidapi-key": "db65a00b87mshdf60744ea72b454p15a6fcjsn6b136dc31291",
        "x-rapidapi-host": "alpha-vantage.p.rapidapi.com"
    ]
    let request = NSMutableURLRequest(url: NSURL(string: "https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=TSLA")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    

//    https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY_EXTENDED&symbol=IBM&interval=15min&slice=year1month1&apikey=demo
    
    func grabData(){
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })

        dataTask.resume()
    }
    
    
    
    
    
}
