//
//  Order.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import Foundation

class Order {
    var product: Product
    var amount: Int
    
    init(product: Product, amount: Int) {
        self.product = product
        self.amount = amount
    }
    
    func price() -> Double {
        return product.price * Double(amount)
    }
}
