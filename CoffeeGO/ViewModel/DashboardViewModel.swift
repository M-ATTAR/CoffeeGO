//
//  DashboardViewModel.swift
//  CoffeeGO
//
//  Created by Mohamed Attar on 16/12/2021.
//

import Foundation
import RxSwift

class DashboardViewModel {
    let firebaseDB = FirebaseDBManager()
    let bag = DisposeBag()

    var cars = PublishSubject<[CarOwner]>()
    let isLoading = PublishSubject<Bool>()
    
    var carsArray = [CarOwner]()
    
    func subToCars() {
        firebaseDB.carOwnerSubject.subscribe { carOwners in
            self.cars.onNext(carOwners)
            self.carsArray = carOwners
            self.isLoading.onNext(false)
        } onError: { error in
            self.isLoading.onError(error)
        }.disposed(by: bag)
        
        
    }

    func getCars() {
        firebaseDB.getCars()
    }

    private func filterActiveCars() {
        cars.onNext(carsArray.filter {$0.isActive == true})
    }
    private func filterInactiveCars() {
        cars.onNext(carsArray.filter {$0.isActive == false})
    }
    private func filterAllCars() {
        cars.onNext(carsArray)
    }
    
    func filterCars(status: Status) {
        switch status {
        case .all:
            filterAllCars()
        case .active:
            filterActiveCars()
        case .inactive:
            filterInactiveCars()
        }
    }
    
    func deleteCar(uid: String) {
        firebaseDB.deleteCarOwner(uid: uid)
    }
    func searchCar(status: Status,_ text: String) {
        
        switch status {
        case .all:
            cars.onNext(carsArray.filter { $0.name!.contains(text) || $0.city!.contains(text) } )
        case .active:
            cars.onNext(carsArray.filter { ($0.name!.contains(text) || $0.city!.contains(text)) && $0.isActive == true } )
        case .inactive:
            cars.onNext(carsArray.filter { ($0.name!.contains(text) || $0.city!.contains(text)) && $0.isActive == false } )
        }

    }
    func cancelSearch(status: Status) {
        switch status {
        case .all:
            filterAllCars()
        case .active:
            filterActiveCars()
        case .inactive:
            filterInactiveCars()
        }
    }
}
