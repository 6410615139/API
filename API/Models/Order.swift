//
//  Order.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import Foundation

class Order: ObservableObject{
    var product: Product
    var amount: Int
    
    init(product: Product, amount: Int) {
        self.product = product
        self.amount = amount
    }
    
    func price() -> Double {
        if self.product.discount_percent == 0 {
            return product.price * Double(amount)
        } else {
            return product.discount(percentage: product.discount_percent) * Double(amount)
        }
    }
}
