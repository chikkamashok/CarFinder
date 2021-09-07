//
//  CarData.swift
//  CarFinder
//
//  Created by Ashok Chikkam on 9/7/21.
//

import Foundation

struct CarData: Decodable {
    
    let listings: [CarListing]
}

struct CarListing: Decodable {
    
    let year: Int?
    let make: String?
    let model: String?
    let trim: String?
    let currentPrice: Double?
    let mileage: Int?
    let images: CarImageSet?
    let dealer: Dealer?
}

struct Dealer: Decodable {
    
    let city: String?
    let state: String?
    let phone: String?
}

struct CarImageSet: Decodable {
    
    let baseUrl: String?
    let large: [String]
    let medium: [String]
    let small: [String]
}
