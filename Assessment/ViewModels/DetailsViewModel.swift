//
//  DetailsViewModel.swift
//  Assessment
//
//  Created by Naval Hasan on 01/12/20.
//  Copyright © 2020 Bankaks. All rights reserved.
//

import Foundation

class DetailsViewModel {
    var serviceDetailsArray = [ServiceDetailsModel]()
    weak var detailsViewController : DetailsViewController?
    
    func getDetailsData() {
        let selectedIndex = detailsViewController?.typeValue
        let url = URL(string: "https://api-staging.bankaks.com/task/\(selectedIndex ?? "1")")!
        URLSession.shared.dataTask(with: url) { (data , response, error) in
            if error == nil {
                if let data = data {
                    do {
                        let dataResponse = try JSONDecoder().decode(ServiceDetailsModel.self, from: data)
                        self.serviceDetailsArray.append(dataResponse)
                        self.detailsViewController?.setupUI()
                        DispatchQueue.main.async {
                            self.detailsViewController?.detailsTableView.reloadData()
                        }
                    }
                    catch let err {
                        print(err.localizedDescription)
                    }
                }
            }
            else {
                print(error?.localizedDescription ?? "No description available")
            }
        }.resume()
    }
}
