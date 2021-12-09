//
//  RegisterViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 08/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var register: UIButton!
    
    var viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.createAccountTitle
        self.hideKeyboardWhenTappedAround()
        
        firstNameTF.clipsToBounds = true
        firstNameTF.layer.cornerRadius = 10
        firstNameTF.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        lastNameTF.clipsToBounds = true
        lastNameTF.layer.cornerRadius = 10
        lastNameTF.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        phoneNumberTF.clipsToBounds = true
        phoneNumberTF.layer.cornerRadius = 10
        phoneNumberTF.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        email.clipsToBounds = true
        email.layer.cornerRadius = 10
        email.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        password.clipsToBounds = true
        password.layer.cornerRadius = 10
        password.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        confirmPassword.clipsToBounds = true
        confirmPassword.layer.cornerRadius = 10
        confirmPassword.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        
        firstNameTF.rx.text.orEmpty.bind(to: viewModel.firstName).disposed(by: disposeBag)
        lastNameTF.rx.text.orEmpty.bind(to: viewModel.lastName).disposed(by: disposeBag)
        phoneNumberTF.rx.text.orEmpty.bind(to: viewModel.phoneNumber).disposed(by: disposeBag)

        email.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        password.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPassword.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: register.rx.isEnabled).disposed(by: disposeBag)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        viewModel.register(email: email.text!, password: password.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: K.verificationVCID) as! VerificationViewController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(vc)
            }
        }
    }

}
