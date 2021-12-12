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

        bindUI()
    }
    
    func bindUI() {
        firstNameTF.rx.text.orEmpty.bind(to: viewModel.firstName).disposed(by: disposeBag)
        lastNameTF.rx.text.orEmpty.bind(to: viewModel.lastName).disposed(by: disposeBag)
        phoneNumberTF.rx.text.orEmpty.bind(to: viewModel.phoneNumber).disposed(by: disposeBag)

        email.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)

        password.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPassword.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)
        
        viewModel.isValid.map { $0 }.bind(to: register.rx.isEnabled).disposed(by: disposeBag)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) { // TODO: Change to RX AND ADD ROUTING
        viewModel.register(email: email.text!, password: password.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
//                let vc = UIStoryboard(name: K.mainStoryboard, bundle: .main).instantiateViewController(withIdentifier: K.verificationVCID) as! VerificationViewController
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(vc)
            }
        }
    }

}
