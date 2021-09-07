//
//  CarListViewModel.swift
//  CarFinder
//
//  Created by Ashok Chikkam on 9/7/21.
//

import Foundation

class CarListViewModel {
    
    private var apiService = APIService()
    private var carListings = [CarListing]()
    
    func fetchCarListings(completion: @escaping () -> ()) {
        
        apiService.getCarsAvailable { [weak self] (result) in
            
            switch result {
            case .success(let data):
                self?.carListings = data.listings
                completion()
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if carListings.count != 0 {
            return carListings.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> CarListing {
        return carListings[indexPath.row]
    }
}
