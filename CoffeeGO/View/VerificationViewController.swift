//
//  VerificationViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class VerificationViewController: UIViewController {
    
    let viewModel = VerificationViewModel()
    var role: String?
    
    @IBOutlet weak var roleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.printUserData()
        
        roleLabel.text = role
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        viewModel.signOut() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let nc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: K.rootNC) as! UINavigationController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(nc)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
}
