//
//  AppetizerListViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Tatsuya Moriguchi on 3/31/22.
//

import Foundation

// Use class for view model since you want to maintain state in the view model
// final keyword: You cannot subclass it for optimaization
// ObservableObject: Object is able to be observed
final class AppetizerListViewModel: ObservableObject {

    // @Published keyword: Because of ObservableObject, anytime one of @Published variables changed,
    // @Published monitors that variable for any change, SwiftUI updates UI.
    // Change View to listen to the change
    @Published var appetizers: [Appetizer] = []
    @Published var isLoading = false
    @Published var alertItem: AlertItem?

    func getAppetizers() {
        isLoading = true
        
        NetworkManager.shared.getAppetizers { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let appetizers):
                    self.appetizers = appetizers
                    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        alertItem = AlertContext.invalidData
                        
                    case .invalidURL:
                        alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        alertItem = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
    
    
}
