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
        
        self.carModelDetails.text = listing.make
        self.carPriceDetails.text = "\(listing.currentPrice)"
        self.carDealerContact.setTitle(listing.dealer?.phone, for: .normal)
        guard let urlString = listing.images?.small.first, let imageUrl = URL(string: urlString) else {
            self.carImageView.image = UIImage(named: "noImageAvailable")
            return
        }
        self.carImageView.image = nil
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
                if let image = UIImage(data: data) {
                    self.carImageView.image = image
                }
            }
        }.resume()
    }
}
