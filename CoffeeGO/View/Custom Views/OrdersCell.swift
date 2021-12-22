//
//  OrdersCell.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 17/12/2021.
//

import UIKit

class OrdersCell: UITableViewCell {

    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    
    var order: Order? {
        didSet {
            orderIDLabel.text = order?.orderID
            orderTotalPrice.text = "$\(order?.price ?? 0.0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
