//
//  Date+Ext.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 20/12/2021.
//

import Foundation


extension Date {
    func convertToStringDate() -> String {
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "MMMM dd, yyyy"

        // Convert Date to String
        return dateFormatter.string(from: self)
    }
    
    
    func convertToStringTime() -> String {
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        // Convert Date to String
        return dateFormatter.string(from: self)
    }
}
