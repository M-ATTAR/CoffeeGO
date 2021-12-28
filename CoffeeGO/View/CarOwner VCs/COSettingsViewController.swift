//
//  COSettingsViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 27/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class COSettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let viewModel = COSettingsViewModel()
    let bag = DisposeBag()
    
    let settingsArray = [["Export Data"], ["Active", "Change Password", "Change Email"], ["Sign out" ,"Contact Us"]]
    let settingsSections = ["Data","Profile", "Name Later"]
    
    let settingsSwitch = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subToActiveSubject()
        viewModel.subToFirebase()
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "coSettingCell")
        settingsTableView.backgroundColor = .clear
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        settingsSwitch.tag = 0
        settingsSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        settingsSwitch.onTintColor = Colors.backgroundC!
    }
    func subToActiveSubject() {
        viewModel.isActiveSubject.subscribe { isActive in
            self.settingsSwitch.isOn = isActive
        }.disposed(by: bag)
    }
    @objc func switchTapped(_ sender: UISwitch) {
        if sender.tag == 0 {
            viewModel.manageStatus(newStatus: sender.isOn)
        }
    }
}

extension COSettingsViewController: UITableViewDataSource, UITableViewDelegate { // TODO: Change to RX
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coSettingCell", for: indexPath)
        
        let item = settingsArray[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = item
        cell.textLabel?.textColor = Colors.backgroundC!
        cell.backgroundColor = Colors.foregroundC!
        
        if item == "Active" {
            cell.accessoryView = settingsSwitch
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingsArray[indexPath.section][indexPath.row] == "Sign out" {
            viewModel.signout().subscribe { didSignOut in
                if didSignOut {
                    let nc = UIStoryboard(name: Storyboard.mainStoryboard, bundle: .main).instantiateViewController(withIdentifier: ID.rootNC) as! UINavigationController
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(nc)
                }
            } onError: { error in
                self.errorAlert(title: "Something wrong happened", message: error.localizedDescription, buttonTitle: "OK")
            }.disposed(by: bag)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func signOut() {
        let firebaseAuth = FirebaseAuthManager()
        firebaseAuth.signOut { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let nc = UIStoryboard(name: Storyboard.mainStoryboard, bundle: .main).instantiateViewController(withIdentifier: ID.rootNC) as! UINavigationController
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(nc)
            }
        }
    }
}
