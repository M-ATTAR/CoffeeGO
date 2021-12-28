//
//  COOrdersViewController.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 24/12/2021.
//

import UIKit
import RxSwift
import RxCocoa

class COOrdersViewController: UIViewController {
    
    @IBOutlet weak var orderStatusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let viewModel = COOrdersViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        subToOrders()
        viewModel.subToFirebase()
        subToError()
        
        bindTableData()
        viewModel.getOrders()
        datePicker.isHidden = true
    }
    
    func setupUI() {
        ordersTableView.register(UINib(nibName: "COOrdersCell", bundle: nil), forCellReuseIdentifier: "COOrdersCell")
        ordersTableView.backgroundColor = .clear
        ordersTableView.allowsSelection = false
    }
    
    func subToOrders() {
        viewModel.ordersDidCome.subscribe { didCome in
            if didCome.element! {
                self.viewModel.filterOrders(orderStatus: OrderStatus(rawValue: (self.orderStatusSegmentedControl.selectedSegmentIndex)) ?? .pending)
            }
        }.disposed(by: bag)

    }
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let index = orderStatusSegmentedControl.selectedSegmentIndex
        let orderStatus = OrderStatus(rawValue: index)!
        viewModel.filterOrdersBy(timestamp: sender.date, withOrderStatus: orderStatus)
    }
    
    func subToError() {
        viewModel.errorSubject.subscribe(onNext: nil) { error in
            self.errorAlert(title: "Something wrong happened", message: error.localizedDescription, buttonTitle: "OK")
        }.disposed(by: bag)

    }
    
    @IBAction func orderStatusChange(_ sender: UISegmentedControl) { // TODO: BUG FILTERING DOESNT WORK PROPERLY IN 3...4.
        self.viewModel.filterOrders(orderStatus: OrderStatus(rawValue: (sender.selectedSegmentIndex)) ?? .pending)
        
        switch sender.selectedSegmentIndex {
        case 0...2:
            datePicker.isHidden = true
        case 3:
            datePicker.isHidden = false
            datePicker.date = Date()
            viewModel.filterOrdersBy(timestamp: Date(), withOrderStatus: .done)
        case 4:
            datePicker.isHidden = false
            datePicker.date = Date()
            viewModel.filterOrdersBy(timestamp: Date(), withOrderStatus: .declined)
        default:
            datePicker.isHidden = true
        }
    }
}

extension COOrdersViewController {
    func bindTableData() {
        // Bind articles to table.
        viewModel.ordersSubject.bind(to: ordersTableView.rx.items(cellIdentifier: "COOrdersCell", cellType: COOrdersCell.self)) { row, order, cell in
            cell.order = order
            
            let index = self.orderStatusSegmentedControl.selectedSegmentIndex
            
            cell.rightButtonTapped = { self.viewModel.manageOrders(orderStatus: OrderStatus(rawValue: index)!, orderID: order.orderID) }
            cell.leftButtonTapped  = { self.viewModel.manageOrders(orderStatus: .declined, orderID: order.orderID)}
            
//            if index == 1 {
//                cell.rightButtonTapped = {self.viewModel.markOrderAsReady()}
//            } else if index == 2 {
//                cell.rightButtonTapped = {self.viewModel.markOrderAsDone()}
//            } else if index == 0 {
//                cell.leftButtonTapped  = {self.viewModel.declineOrder()}
//                cell.rightButtonTapped = {self.viewModel.acceptOrder()}
//            }
//
//            cell.acceptButtonTapped    = { self.viewModel.acceptOrder() }
//
//            cell.declineButtonTapped   = { self.viewModel.acceptOrder() }
//
//            cell.markReadyButtonTapped = { self.viewModel.markOrderAsReady() }
//
//            cell.markDoneButtonTapped  = { self.viewModel.markOrderAsDone() }
            
        }.disposed(by: bag)
        
        // Bind a model selected handler (When someone selects a tableView row
//        carsTableView.rx.modelSelected(CarOwner.self).bind { carOwner in
//            // Push ViewController
//            self.carDetailsVC.carOwner = carOwner
////            self.carDetailsVC.modalPresentationStyle = .overFullScreen
////            self.present(self.carDetailsVC, animated: true)
//            self.navigationController?.pushViewController(self.carDetailsVC, animated: true)
//        }.disposed(by: bag)
    }
}
