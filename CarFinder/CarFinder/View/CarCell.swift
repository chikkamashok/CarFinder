//
//  CarCell.swift
//  CarFinder
//
//  Created by Ashok Chikkam on 9/7/21.
//

import UIKit

class CarCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carModelDetails: UILabel!
    @IBOutlet weak var carPriceDetails: UILabel!
    @IBOutlet weak var carDealerContact: UIButton!
    
    // MARK: Methods
    func updateCellWith(_ listing: CarListing) {
        
        self.carModelDetails.text = getCarModelDetails(listing)
        self.carPriceDetails.text = getCarPriceDetails(listing)
        self.carDealerContact.setTitle(listing.dealer?.phone, for: .normal)
        guard let urlString = listing.images?.small.first, let imageUrl = URL(string: urlString) else {
            self.carImageView.image = UIImage(named: "noImageAvailable")
            return
        }
//        self.carImageView.image = nil
        getImageDataFrom(url: imageUrl)
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data), image.size.height > 10.0 {
                    print(image.size.height)
                    self.carImageView.image = image
                }
            }
        }.resume()
    }
}

extension CarCell {
    
    // MARK: Helper methods
    private func getCarModelDetails(_ listing: CarListing) -> String {
        
        let year = (listing.year != nil) ? String(listing.year!) : ""
        let make = listing.make ?? ""
        let model = listing.model ?? ""
        return year + " " + make + " " + model
    }
    
    private func getCarPriceDetails(_ listing: CarListing) -> String {
        
        let price = "$" + ((listing.currentPrice != nil) ? String(Int(listing.currentPrice!)) : "")
        let mileage = (listing.mileage != nil) ? String(listing.mileage!) : ""
        let city = listing.dealer?.city ?? ""
        let state = listing.dealer?.state ?? ""
        let location = city + ", " + state
        return price + " | " + mileage + " | " + location
    }
}
