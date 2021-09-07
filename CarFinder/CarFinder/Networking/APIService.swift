//
//  APIService.swift
//  CarFinder
//
//  Created by Ashok Chikkam on 9/7/21.
//

import Foundation

class APIService {
    
    private var dataTask: URLSessionDataTask?
    
    func getCarsAvailable(completion: @escaping (Result<CarData, Error>) -> Void) {
        
        let fetchUrl = "https://carfax-for-consumers.firebaseio.com/assignment.json"
        guard let url = URL(string: fetchUrl) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                print("no data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(CarData.self, from: data)
                print(jsonData)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
