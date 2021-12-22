//
//  RequestsCell.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 18/12/2021.
//

import UIKit

class RequestsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var cellView: UIView!
    
    var request: Request? {
        didSet {
            self.nameLabel.text = request?.name
            self.cityLabel.text = request?.city
        }
    }

    var acceptButtonTapped: () -> ()  = { }
    var declineButtonTapped: () -> ()  = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        cellView.layer.cornerRadius = 15
        
        acceptButton.addAction(UIAction(handler: { _ in
            self.acceptButtonTapped()
        }), for: .touchUpInside)
        declineButton.addAction(UIAction(handler: { _ in
            self.declineButtonTapped()
        }), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
