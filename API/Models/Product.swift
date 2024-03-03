//
//  Product.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import Foundation

class Product: Identifiable {
    @Published var name: String
    @Published var price: Double
    @Published var discount_percent: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
        self.discount_percent = 0
    }
    
    init(name: String, price: String) {
        self.name = name
        self.price = Double(price) ?? 0.0
        self.discount_percent = 0
    }
    
    func edit_product(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    func edit_product(name: String, price: String) {
        self.name = name
        self.price = Double(price)!
    }
    
    func discount(percentage: Double) -> Double {
        return self.price - (self.price * percentage)
    }
}
