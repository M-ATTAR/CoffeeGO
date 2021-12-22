//
//  OrderDetailsView.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 20/12/2021.
//

import UIKit
import FirebaseFirestore

@IBDesignable class OrderDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderDetailsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var leftRoundedView: UIView!
    @IBOutlet weak var rightRoundedView: UIView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    var order: Order? {
        didSet {
            orderIDLabel.text = order?.orderID
            placeNameLabel.text = order?.carOwnerName
            customerNameLabel.text = order?.userName
            totalPriceLabel.text = "Total Price: $\(order?.price ?? 0.0)"
            
            statusLabel.text = order?.status
            
            orderDetailsLabel.text = setOrderDetailsStringFormat(order?.orderDetails)
//            orderDetailsLabel.sizeToFit()
            
            dateLabel.text = order?.timestamp?.dateValue().convertToStringDate()
            timeLabel.text = order?.timestamp?.dateValue().convertToStringTime()
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configNib()
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("OrderDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        config()
    }
    
    func config() {
        
        leftRoundedView.layer.cornerRadius = 15
        rightRoundedView.layer.cornerRadius = 15
        
        orderView.layer.cornerRadius = 20
        statusView.layer.cornerRadius = 15
    }
    
    func setStatusLabelColor(status: String?) {
        guard let status = status else {
            return
        }
        
        if status == "Pending" {
           
        } else if status == "Preparing" {
            
        } else if status == "Ready For Pickup" {
            
        } else if status == "Done" {
            
        } else if status == "Decline" {
            
        }
    }
    func setOrderDetailsStringFormat(_ str: String?) -> String {
        guard let str = str else {
            return ""
        }
        
        let orderDetails = str.components(separatedBy: ", ")
        
        print(orderDetails)
        
        var orderD = ""
        var orderPrice = ""
        
        for orderDetail in orderDetails {
            
            let secondSplit = orderDetail.components(separatedBy: " - ")
            orderD += "\n\(secondSplit[0]) x \(secondSplit[1]) ...... \(secondSplit[2])"
        }
        
        orderD.removeFirst()
        
        return orderD
    }
}

// 1 - Latte - $12.50, 1 - Iced Tea - 25.0
