//
//  COOrdersCell.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 26/12/2021.
//

import UIKit

class COOrdersCell: UITableViewCell {
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var orderItemsLabel: UILabel!
    @IBOutlet weak var orderItemsPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var receiptView: UIView!
    
//    var acceptButtonTapped: () -> ()  = { }
//    var declineButtonTapped: () -> ()  = { }
//    var markReadyButtonTapped: () -> ()  = { }
//    var markDoneButtonTapped: () -> ()  = { }
    
    var leftButtonTapped: () -> () = {}
    var rightButtonTapped: () -> () = {}
    
    var order: Order? {
        didSet {
            customerNameLabel.text = order?.userName
            totalPriceLabel.text = "Total Price: \(order?.price ?? 0.0)"
            dateLabel.text = "\(order!.timestamp!.dateValue().convertToStringDate()) - \(order!.timestamp!.dateValue().convertToStringTime())"
            
            orderItemsLabel.text = setOrderDetailsStringFormat(isPrice: false, order?.orderDetails)
            orderItemsPriceLabel.text = setOrderDetailsStringFormat(isPrice: true, order?.orderDetails)
            
            if let status = order?.status {
                if status == "Pending" {
                    
                    leftButton.setTitle("Decline", for: .normal)
                    leftButton.isHidden = false
                    rightButton.isHidden = false
                    rightButton.setTitle("Accept", for: .normal)
                    
//                    leftButton.addAction(UIAction(handler: { _ in
//                        self.declineButtonTapped()
//                    }), for: .touchUpInside)
//
//                    rightButton.addAction(UIAction(handler: { _ in
//                        self.acceptButtonTapped()
//                    }), for: .touchUpInside)
//
                } else if status == "Preparing" {
                    
                    leftButton.isHidden = true
                    rightButton.isHidden = false
                    rightButton.setTitle("Mark Ready for Pickup", for: .normal)
                    
//                    rightButton.addAction(UIAction(handler: { _ in
//                        self.markReadyButtonTapped()
//                    }), for: .touchUpInside)
                    
                } else if status == "Ready For Pickup" {
                    leftButton.isHidden = true
                    rightButton.isHidden = false
                    rightButton.setTitle("Mark Done", for: .normal)
                    
//                    rightButton.addAction(UIAction(handler: { _ in
//                        self.markDoneButtonTapped()
//                    }), for: .touchUpInside)
//
                } else if status == "Done" {
                    leftButton.isHidden = true
                    rightButton.isHidden = true
                } else if status == "Declined" {
                    leftButton.isHidden = true
                    rightButton.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftView.layer.cornerRadius = 16
        rightView.layer.cornerRadius = 16
        receiptView.layer.cornerRadius = 20
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        leftButton.addAction(UIAction(handler: { _ in
            self.leftButtonTapped()
        }), for: .touchUpInside)
        
        rightButton.addAction(UIAction(handler: { _ in
            self.rightButtonTapped()
        }), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrderDetailsStringFormat(isPrice: Bool, _ str: String?) -> String {
        guard let str = str else {
            return ""
        }
        
        let orderDetails = str.components(separatedBy: ", ")
        
        print(orderDetails)
        
        var orderD = ""
        var orderPrice = ""
        
        for orderDetail in orderDetails {
            
            let secondSplit = orderDetail.components(separatedBy: " - ")
            orderD += "\n\(secondSplit[0]) x \(secondSplit[1])"
            orderPrice += "\n\(secondSplit[2])"
        }
        print(orderPrice)
        
        orderD.removeFirst()
        orderPrice.removeFirst()
        
        switch isPrice {
        case true:
            return orderPrice
        case false:
            return orderD
        }
    }
    
}
