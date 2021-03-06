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
    var ticker = ""
    
    let headers = [
        "x-rapidapi-key": "db65a00b87mshdf60744ea72b454p15a6fcjsn6b136dc31291",
        "x-rapidapi-host": "alpha-vantage.p.rapidapi.com"
    ]
    var request: NSMutableURLRequest
    
    override init(){
        request = NSMutableURLRequest(url: NSURL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=" + AlphaVAPIKey)! as URL,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
    }

    
    
    func grabData(_ completion: @escaping(_ error: Error?, _ open: Double, _ high: Double, _ chartDatas: [ChartDataEntry]) -> Void){
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request = NSMutableURLRequest(url: NSURL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(ticker)&interval=5min&apikey=" + AlphaVAPIKey)! as URL,
          cachePolicy: .useProtocolCachePolicy,
          timeoutInterval: 10.0)

        var chartDatasToMake: [ChartDataEntry] = []
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(error, 0.0, 0.0, [])
            } else {
                var open: Double = 0.0
                var high: Double = 0.0
                var timeToValueDict: [Double: Double] = [:]
                
                if let string = String(bytes: data!, encoding: .utf8) {
                    let dict = string.toJSON() as? [String:AnyObject]
                    
                    if let timeData = dict?["Time Series (5min)"] as? [String: Any]{
                        //Go through all times returned
                        for timePos in timeData{
                            //parse the last bit out of timePos.key
                            //2021-01-27 15:30:00 -> 15:30:00
                            let dateTime = timePos.key.suffix(8)
                            //Convert 15:30:00 -> Double
                            let seconds = Double(dateTime.suffix(2)) ?? 0
                            let hoursAndMin = dateTime.prefix(5)
                            let min = (Double(hoursAndMin.suffix(2)) ?? 0) * 60
                            let hours = (Double(hoursAndMin.prefix(2)) ?? 0) * 60 * 60
                            let timeInDouble = hours + min + seconds
                            
                            //Get stock value at this current time
                            if let timeDict = timePos.value as? NSDictionary{
                                let stockValue = timeDict["1. open"] as? String
                                let stockValueDouble = Double(stockValue ?? "0.0")
                                if (stockValueDouble ?? 0.0) > high{
                                    high = stockValueDouble ?? 0.0
                                }
                                //Open time
                                if timeInDouble == 39600.00{
                                    open = stockValueDouble ?? 0.0
                                }
                                timeToValueDict[timeInDouble] = stockValueDouble
                            }
                        }
                        let sortedDict = Array(timeToValueDict.keys).sorted(by: <)
                        for time in sortedDict{
                            chartDatasToMake.append(ChartDataEntry(x: time, y: timeToValueDict[time] ?? 0.0))
                        }
                        completion(nil, open, high, chartDatasToMake)
                    }
                } else {
                    print("not a valid UTF-8 sequence")
                }
            }
        })
        dataTask.resume()
    }
}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}


extension Double {
    static var MIN     = -DBL_MAX
    static var MAX_NEG = -DBL_MIN
    static var MIN_POS =  DBL_MIN
    static var MAX     =  DBL_MAX
}
