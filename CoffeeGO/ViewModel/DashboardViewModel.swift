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
//        isLoading.onNext(true)
        firebaseDB.getCars()
    }

    func filterActiveCars() {
        cars.onNext(carsArray.filter {$0.isActive == true})
    }
    func filterInactiveCars() {
        cars.onNext(carsArray.filter {$0.isActive == false})
    }
    func filterAllCars() {
        cars.onNext(carsArray.filter {$0.isActive == true || $0.isActive == false})
    }
    func deleteCar(uid: String) {
        firebaseDB.deleteCarOwner(uid: uid)
    }
}
