//
//  Form4XMLParser.swift
//  Insider
//
//  Created by John Baer on 1/23/21.
//

import UIKit

class Form4XMLParser: NSObject {
    var song: String?
    var artist: String?
    
    class func requestSong(_ xmlURL: String, completionHandler: @escaping (String?, String?, Error?) -> Void) {
        let url = URL(string: xmlURL)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
                return
            }
            
            print("hm")
            
            let delegate = Form4XMLParser()
            let parser = XMLParser(data: data)
            parser.delegate = delegate
            DispatchQueue.main.async {
                completionHandler(delegate.song, delegate.artist, parser.parserError)
            }
        }
        task.resume()
    }
}

extension Form4XMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "Song":   song   = attributeDict["transactionAcquiredDisposedCode"]
        case "Artist": artist = attributeDict["transactionAcquiredDisposedCode"]
        default:       break
        }
    }
}
