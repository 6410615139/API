//
//  Product.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import Foundation

class Product: ObservableObject{
    @Published var name: String
    @Published var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    func edit_product(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    func discount(percentage: Double) -> Double {
        return self.price - (self.price * percentage)
    }
    
}
