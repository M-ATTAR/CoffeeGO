//
//  CarsCell2.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 17/12/2021.
//

import UIKit

class CarsCell2: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var isActive: Bool?
    
    var location: String? {
        didSet {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 10)
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(Colors.backgroundC!.withAlphaComponent(0.9)).withConfiguration(largeConfig)
            
            let fullString = NSMutableAttributedString(attachment: imageAttachment)
            fullString.append(NSAttributedString(string: " \(location ?? "N/A" )"))
            locationLabel.attributedText = fullString
            locationLabel.textColor = Colors.backgroundC?.withAlphaComponent(0.9)
        }
    }
    
    var name: String? {
        didSet {
            let imageAttachment = NSTextAttachment()
            if let isActive = isActive {
                imageAttachment.image = UIImage(systemName: "circle.fill")?.withTintColor(isActive ? .systemGreen : .systemRed)
            }
            let fullString = NSMutableAttributedString(attachment: imageAttachment)
            fullString.append(NSAttributedString(string: " \(name ?? "N/A" )"))
            nameLabel.attributedText = fullString
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 15
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
