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
        self.carPriceDetails.attributedText = getCarPriceDetails(listing)
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
                if let image = UIImage(data: data), image.size.height > 10.0 {
                    print(image.size.height)
                    self.carImageView.image = image
                } else {
                    self.carImageView.image = UIImage(named: "noImageAvailable")
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
    
    private func getCarPriceDetails(_ listing: CarListing) -> NSMutableAttributedString {
        
        let price = "$" + ((listing.currentPrice != nil) ? String(Int(listing.currentPrice!)) : "")
        
        let mileage = (listing.mileage != nil) ? getFormattedMileage(listing.mileage!) : ""
        let city = listing.dealer?.city ?? ""
        let state = listing.dealer?.state ?? ""
        let location = city + ", " + state
        let normalText = "  |  " + mileage + "  |  " + location
        
        return NSMutableAttributedString()
            .bold(price)
            .normal(normalText)
    }
    
    private func getFormattedMileage(_ mileage: Int) -> String {
        
        if mileage > 1000 {
            return String(Int(mileage/1000)) + "k Mi"
        } else {
            return String(Int(mileage)) + " Mi"
        }
    }
    
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
