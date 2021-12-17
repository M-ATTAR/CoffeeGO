//
//  ViewController+Ext.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 15/12/2021.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func errorAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    func loadingMessage(_ message: String) -> UIAlertController {
        let waitingAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        waitingAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Colors.darkBrown
        waitingAlert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20,weight: UIFont.Weight.medium),NSAttributedString.Key.foregroundColor: UIColor.white]), forKey: "attributedMessage")

        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        waitingAlert.view.addSubview(loadingIndicator)
        
        return waitingAlert
    }
}
