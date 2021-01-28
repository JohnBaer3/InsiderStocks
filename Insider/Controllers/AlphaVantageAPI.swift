//
//  AlphaVantageAPI.swift
//  Insider
//
//  Created by John Baer on 1/27/21.
//

import Foundation
import Charts
import TinyConstraints

class AlphaVantageAPI: NSObject {
    
    let session = URLSession.shared

    let AlphaVAPIKey = "XJVXO6EZYER7SP5J"
    
    let headers = [
        "x-rapidapi-key": "db65a00b87mshdf60744ea72b454p15a6fcjsn6b136dc31291",
        "x-rapidapi-host": "alpha-vantage.p.rapidapi.com"
    ]
    let request: NSMutableURLRequest
    
    override init(){
        request = NSMutableURLRequest(url: NSURL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=" + AlphaVAPIKey)! as URL,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        
    }

    
    
    func grabData(_ completion: @escaping(_ success: Bool, _ open: String, _ high: String, _ close: String, _ chartDatas: [ChartDataEntry]) -> Void){
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        var chartDatasToMake: [ChartDataEntry] = []
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            let dataTask = self?.session.dataTask(with: self!.request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    if let string = String(bytes: data!, encoding: .utf8) {
                        let dict = string.toJSON() as? [String:AnyObject] // can be any type here
                        
                        let timeData = dict?["Time Series (5min)"] as! [String: Any]
                        for timePos in timeData{
                            print(timePos)
                            //parse the last bit out of timePos.key
                            //  2021-01-27 15:30:00
                            let dateTime = timePos.key.suffix(4)


                            
                            //get open out of
                            /*
                             value: {
                                 "1. open" = "123.7900";
                                 "2. high" = "123.8600";
                                 "3. low" = "123.3400";
                                 "4. close" = "123.4800";
                                 "5. volume" = 136729;
                             }
                             */
                            
                            //Add them onto
                            chartDatasToMake.append(ChartDataEntry(x: 0.0, y: 0.0))
                        }
                        //Go through the dictionary, for each date add it onto the chartDatas array
                        
                    } else {
                        print("not a valid UTF-8 sequence")
                    }
                }
            })
            
            dataTask?.resume()
            }
    }
}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
