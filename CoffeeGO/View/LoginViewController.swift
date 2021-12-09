//
//  ViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        email.layer.cornerRadius = 10
        email.clipsToBounds = true
        email.backgroundColor = .systemBrown.withAlphaComponent(0.3)
    
        password.layer.cornerRadius = 10
        password.clipsToBounds = true
        password.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        registerButton.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        registerButton.layer.cornerRadius = 10
        
        forgotPassword.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        forgotPassword.layer.cornerRadius = 10
        
        email.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        password.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: login.rx.isEnabled).disposed(by: disposeBag)
    }

    @IBAction func tapped(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: K.verificationVCID) as! VerificationViewController
        
        viewModel.signIn(email: email.text!, password: password.text!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.viewModel.getRole { role in
                    switch (role){
                    case "admin":
                        // Go To Admin
                        vc.role = "Admin"
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("admin")
                    case "user":
                        // Go To User
                        vc.role = "User"
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("user")
                    case "car":
                        // Go To Owner
                        vc.roleLabel.text = "car"
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("car")
                    default:
                        // Error
                        vc.roleLabel.text = "error"
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("error")
                    }
                }
            }
        }
        
    }
    
}

