//
//  BillView.swift
//  API
//
//  Created by Supakrit Nithikethkul on 3/3/2567 BE.
//

import SwiftUI
struct BillView: View {
    @ObservedObject var bill: Bill

    @State private var showingDeleteAlert = false
    
    @State private var orderToDelete: Order?

    var body: some View {
        VStack {
            List {
                ForEach($bill.orders, id: \.product.name) { $order in
                    OrderRow(bill: bill, order: order, showDeleteAlert: { selectedOrder in
                        self.orderToDelete = selectedOrder
                        self.showingDeleteAlert = true
                    })
                }
            }
            .navigationTitle("Bill")
            .navigationBarItems(trailing: Text("Total: \(bill.total_price, specifier: "%.2f")฿ from \(bill.no_discount_price, specifier: "%.2f")฿ (\(bill.total_amount) items)"))
            NavigationLink(destination: QRView(bill: bill)) {
                Text("QR Code")
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            deleteAlert
        }
    }

    var deleteAlert: Alert {
        Alert(
            title: Text("Confirm Delete"),
            message: Text("Are you sure you want to delete this product?"),
            primaryButton: .destructive(Text("Delete")) {
                if let orderToDelete = orderToDelete {
                    bill.remove_order(orderToDelete)
                }
            },
            secondaryButton: .cancel()
        )
    }
}

struct OrderRow: View {
    @ObservedObject var bill: Bill
    @ObservedObject var order: Order
    var showDeleteAlert: (Order) -> Void

    var body: some View {
        VStack {
            HStack {
                Text(order.product.name)
                    .font(.title)
                Spacer()
                Text("\(order.product.price, specifier: "%.2f")฿")
                    .font(.title3)
                    .strikethrough(order.product.discount_percent > 0.0, color: .red)
                    .foregroundColor(order.product.discount_percent > 0 ? .gray : .black)
            }
            HStack {
                if order.product.discount_percent > 0 {
                    let discountedPrice: Double = order.product.discount(percentage: order.product.discount_percent)
                    Text("-\(order.product.discount_percent, specifier: "%.2f")%")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer()
                    Text("\(discountedPrice, specifier: "%.2f")฿")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
            HStack {
                Text("x\(order.amount)")
                Spacer()
                Text("Total: \(order.price(), specifier: "%.2f")")
                Button(action: {
                    showDeleteAlert(order)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
        }
    }
}
