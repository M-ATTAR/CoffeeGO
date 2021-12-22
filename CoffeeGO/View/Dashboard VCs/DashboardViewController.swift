//
//  HomeViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 11/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    
    let viewModel = DashboardViewModel()
    let bag = DisposeBag()
    var loadingAlert = UIAlertController()
    let carDetailsVC = UIStoryboard(name: Storyboard.dashboardStoryboard, bundle: nil).instantiateViewController(withIdentifier: ID.carDetailsID) as! CarDetailsViewController
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var carStatusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var carsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setupUI()
        viewModel.subToCars()
        
        loadingAlert = self.loadingMessage("Loading...")
        subToLoading()
        
        bindTableData()
        
        carDetailsVC.delegate = self
        searchBar.delegate = self
        
        self.present(loadingAlert, animated: true) {
            self.viewModel.getCars()
        }
    }
    
    func subToLoading() {
        viewModel.isLoading.subscribe { isLoading in
            switch isLoading {
            case true:
                self.present(self.loadingAlert, animated: true)
                print("PRESENTTTTTTT")
            case false:
                self.loadingAlert.dismiss(animated: true)
                print("DISMISSSSSSS")
            }
        } onError: { error in
            self.errorAlert(title: "Something wrong happened", message: error.localizedDescription, buttonTitle: "OK")
        }.disposed(by: bag)

    }
    
    func setupUI() {
        // Segmented Control
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        
        carStatusSegmentedControl.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        carStatusSegmentedControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        // Table View
        carsTableView.register(UINib(nibName: "CarsCell", bundle: nil), forCellReuseIdentifier: "CarsCell")
        carsTableView.register(UINib(nibName: "CarsCell2", bundle: nil), forCellReuseIdentifier: "CarsCell2")
        carsTableView.backgroundColor = .clear
        carsTableView.separatorStyle = .none
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        viewModel.filterCars(status: Status(rawValue: carStatusSegmentedControl.selectedSegmentIndex)!)
    }
    
    
}

extension DashboardViewController: ModalPresentation {
    func bindTableData() {
        // Bind articles to table.
        viewModel.cars.bind(to: carsTableView.rx.items(cellIdentifier: "CarsCell2", cellType:CarsCell2.self)) { row, carOwner, cell in
            
            cell.isActive = carOwner.isActive
            cell.name = carOwner.name
            cell.location = carOwner.city
            
        }.disposed(by: bag)
        
        // Bind a model selected handler (When someone selects a tableView row
        carsTableView.rx.modelSelected(CarOwner.self).bind { carOwner in
            // Push ViewController
            self.carDetailsVC.carOwner = carOwner
//            self.carDetailsVC.modalPresentationStyle = .overFullScreen
//            self.present(self.carDetailsVC, animated: true)
            self.navigationController?.pushViewController(self.carDetailsVC, animated: true)
        }.disposed(by: bag)
    }
    
    func modalPresentationEnded() {
//        self.present(loadingAlert, animated: true) {
//            self.viewModel.getCars()
//        }
    }
}

extension DashboardViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch(status: Status(rawValue: carStatusSegmentedControl.selectedSegmentIndex)! )
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.searchCar(status: Status(rawValue: carStatusSegmentedControl.selectedSegmentIndex)!, searchText)
        
        
        if searchText.isEmpty {
            viewModel.cancelSearch(status: Status(rawValue: carStatusSegmentedControl.selectedSegmentIndex)!)
        }
    }
}
