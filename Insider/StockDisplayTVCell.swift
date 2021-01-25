//
//  StockDisplayTVCell.swift
//  Insider
//
//  Created by John Baer on 1/25/21.
//

import UIKit

class StockDisplayTVCell: UITableViewCell {

    @IBOutlet weak var companyTicker: UILabel!
    @IBOutlet weak var stockTotalDollars: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var insiderName: UILabel!
    @IBOutlet weak var insiderPosition: UILabel!
    @IBOutlet weak var dollarChange: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
