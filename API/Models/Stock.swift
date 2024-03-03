//
//  Stock.swift
//  API
//
//  Created by Supakrit Nithikethkul on 3/3/2567 BE.
//

import Foundation

class Stock: ObservableObject {
    @Published var container: [Product]
    
    init(_ products: [Product]) {
        container = products
    }
    
    func find_index(_ product: Product) -> Int {
        for (index, my_product) in self.container.enumerated() {
            if product.name == my_product.name {
                return index
            }
        }
        return -1
    }
    
    func is_unique(_ new: Product) -> Bool {
        for product in self.container {
            if new.name == product.name {
                return false
            }
        }
        return true
    }
    
    func is_unique(_ new: Product, product_list: [Product]) -> Bool {
        for product in product_list {
            if new.name == product.name {
                return false
            }
        }
        return true
    }
    
    func add_product(_ new: Product) -> Bool {
        if self.is_unique(new) {
            self.container.append(new)
            return true
        } else {
            return false
        }
    }
    
    func update_product(orig: Product, new: Product) -> Bool {
        var temp = self.container
        temp.remove(at: self.find_index(orig))
        if self.is_unique(new, product_list: temp) {
            let index = find_index(orig)
            self.container[index] = new
            return true
        } else {
            return false
        }
    }
    
    func remove_product(_ remove: Product) -> Bool {
        for product in container {
            if remove.name == product.name {
                return true
            }
        }
        return false
    }
}
