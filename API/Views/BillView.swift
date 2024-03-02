//
//  BillView.swift
//  API
//
//  Created by Supakrit Nithikethkul on 3/3/2567 BE.
//

import SwiftUI

struct BillView: View {
    @ObservedObject var bill: Bill

    var body: some View {
        VStack {
            List(bill.orders, id: \.product.name) { order in
                VStack(alignment: .leading) {
                    Text(order.product.name)
                        .font(.headline)
                    Text("Quantity: \(order.amount)")
                        .font(.subheadline)
                    Text("Price per item: $\(order.product.price, specifier: "%.2f")")
                        .font(.subheadline)
                    Text("Total: $\(order.price(), specifier: "%.2f")")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Bill")
            .navigationBarItems(trailing: Text("Total: $\(bill.total(), specifier: "%.2f")"))
        }
    }
}
