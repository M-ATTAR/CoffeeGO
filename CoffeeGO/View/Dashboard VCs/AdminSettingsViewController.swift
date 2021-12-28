//
//  AdminSettingsViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 13/12/2021.
//

import UIKit

class AdminSettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsArray = ["Sign out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingsTableView.backgroundColor = .clear
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
    }
    
}

extension AdminSettingsViewController: UITableViewDataSource, UITableViewDelegate { // TODO: Change to RX
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = settingsArray[indexPath.row]
        cell.textLabel?.textColor = Colors.backgroundC!
        cell.backgroundColor = Colors.foregroundC!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            signOut()
        }
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
