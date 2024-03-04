//
//  Bill.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import Foundation

class Bill: ObservableObject {
    @Published var orders: [Order]
    @Published var total_amount: Int
    @Published var total_price: Double
    @Published var no_discount_price: Double
    
    init() {
        self.orders = []
        self.total_amount = 0
        self.total_price = 0
        self.no_discount_price = 0
    }
    
    func update() {
        self.total_amount = self.update_amount()
        self.total_price = self.update_price()
        self.no_discount_price = self.update_no_discount_price()
    }

    func update_no_discount_price() -> Double {
        var total: Double = 0
        for order in self.orders {
            total += (order.product.price * Double(order.amount))
        }
        return total
    }
    
    func update_price() -> Double {
        var total: Double = 0
        for order in self.orders {
            total += order.price()
        }
        return total
    }
    
    func update_amount() -> Int {
        var total: Int = 0
        for order in self.orders {
            total += order.amount
        }
        return total
    }
    
    func find_index(_ order: Order) -> Int {
        for (index, my_order) in self.orders.enumerated() {
            if my_order.product.name == order.product.name {
                return index
            }
        }
        return -1
    }
    
    func add_order(_ new_order: Order) {
        let index = find_index(new_order)
        if index == -1 {
            self.orders.append(new_order)
        } else {
            self.orders[index] = new_order
        }
        self.update()
    }
    
    func remove_order(_ order: Order) {
        let index = find_index(order)
        self.orders.remove(at: index)
        self.update()
    }
    
}
