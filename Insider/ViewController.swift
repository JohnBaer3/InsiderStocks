//
//  ViewController.swift
//  Insider
//
//  Created by John Baer on 1/20/21.
//

import UIKit

class ViewController: UIViewController {

    let bla: SECapi = SECapi()
    
    @IBAction func calApi(_ sender: Any) {
        bla.callAPI() { valid, result, num in
            print(result)
            print("Returned to main screen")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bla.callAPI() { valid, result, num in
            print(result)
            print("Returned to main screen")
        }
    }
    

}

