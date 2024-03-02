//
//  Bill.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import Foundation

class Bill: ObservableObject {
    @Published var orders: [Order]
    var total_amount: Int

    init() {
        self.orders = []
        self.total_amount = 0
    }

    func total() -> Double {
        var total: Double = 0
        for order in orders {
            total += order.price()
        }
        return total
    }
    
    func add_order(new_order: Order) {
        var exist = false
        for (index,value) in self.orders.enumerated() {
            if value.product.name == new_order.product.name {
                exist = true
                self.orders[index] = new_order
            }
        }
        if !exist {
            self.orders.append(new_order)
        }
    }
    
    func delete_order(order: Order) {
        for (index,value) in self.orders.enumerated() {
            if value.product.name == order.product.name {
                self.orders.remove(at: index)
            }
        }
    }
    
    
    
}
