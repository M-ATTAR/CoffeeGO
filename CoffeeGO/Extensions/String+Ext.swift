//
//  String+Ext.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 15/12/2021.
//

import Foundation

extension String {
    /// Used to validate if the given string is valid email or not
    ///
    /// - Returns: Boolean indicating if the string is valid email or not
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print("emailTest.evaluate(with: self): \(emailTest.evaluate(with: self))")
        return emailTest.evaluate(with: self)
    }
    
    /// Used to validate if the given string matches the password requirements
    ///
    /// - Returns: Boolean indicating the comparison result
    func isValidPassword() -> Bool {
        print("self.count >= 6: \(self.count >= 6)")
        return self.count >= 6
    }
    func isValidPhoneNumber() -> Bool {
        let phNumberReg = "^\\s*(?:\\+?(\\d{1,3}))?[-. (]*(\\d{3})[-. )]*(\\d{3})[-. ]*(\\d{4})(?: *x(\\d+))?\\s*$"
        let phNTest = NSPredicate(format: "SELF MATCHES %@", phNumberReg)
        return phNTest.evaluate(with: self)
    }
    
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
