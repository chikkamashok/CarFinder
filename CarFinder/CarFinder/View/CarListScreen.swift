//
//  CarListScreen.swift
//  CarFinder
//
//  Created by Ashok Chikkam on 9/7/21.
//

import UIKit

class CarListScreen: UITableViewController {

    private var viewModel = CarListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCarListings()
    }
    
    private func loadCarListings() {
        viewModel.fetchCarListings { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func presentActionSheetToCallDealer(_ contact: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "Call " + contact, style: .default, handler: { _ in
            if let url = URL(string: "tel://" + contact) {
                UIApplication.shared.open(url)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(callAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - TableView
extension CarListScreen {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
        
        let carListing = viewModel.cellForRowAt(indexPath: indexPath)
        cell.updateCellWith(carListing)
        cell.callDelegate = self
        return cell
    }
}

extension CarListScreen: CarCellDelegate {
    func didTappedDealerContact(_ contact: String?) {
        guard let contact = contact else { return }
        presentActionSheetToCallDealer(contact)
    }
}
