//
//  AddAdminViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 14/12/2021.
//

import UIKit

class AddAdminViewController: UIViewController {

    @IBOutlet weak var nameTextField: CGTextField!
    @IBOutlet weak var emailTextField: CGTextField!
    @IBOutlet weak var passwordTextField: CGTextField!
    
    @IBOutlet weak var addButton: CGButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func addButtonTapped(_ sender: CGButton) {
        
        
        
        self.dismiss(animated: true)
    }
    
}
