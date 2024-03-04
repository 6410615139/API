//
//  ProductView.swift
//  API
//
//  Created by Supakrit Nithikethkul on 3/3/2567 BE.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var product: Product
    @ObservedObject var stock: Stock
    @ObservedObject var bill: Bill
    
    @State private var navigateToBillView = false
    
    @State private var showingEditProductSheet = false
    @State private var showingDiscountProductSheet = false
    @State private var showingAddToCartSheet = false
    @State private var showingDeleteAlert = false
    
    @State private var message = ""
    @State private var nameString = ""
    @State private var priceString = ""
    @State private var discountPercentString = "0"
    @State private var amountString = ""

    init(product: Product, stock: Stock, bill: Bill) {
            _product = ObservedObject(initialValue: product)
            _stock = ObservedObject(initialValue: stock)
            _bill = ObservedObject(initialValue: bill)
            _nameString = State(initialValue: product.name)
            _priceString = State(initialValue: "\(product.price)")
        }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Product: \(product.name)")
                .font(.title2)
                .fontWeight(.bold)

            Text("Price: \(product.price, specifier: "%.2f")")
                .font(.title3)
                .strikethrough(product.discount_percent > 0.0, color: .red)
                .foregroundColor(product.discount_percent > 0 ? .gray : .black)

            if product.discount_percent > 0 {
                let discountedPrice: Double = product.discount(percentage: product.discount_percent)
                Text("-\(product.discount_percent, specifier: "%.2f")%: \(discountedPrice, specifier: "%.2f")฿")
                    .font(.title3)
                    .foregroundColor(.red)
            }

            HStack(spacing: 7) {
                Button(action: {
                    showingEditProductSheet = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Button(action: {
                    showingDiscountProductSheet = true
                }) {
                    Image(systemName: "percent")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                Button(action: {
                    showingAddToCartSheet = true
                }) {
                    Image(systemName: "cart")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            NavigationLink(destination: BillView(bill: bill), isActive: $navigateToBillView) {
                EmptyView()}
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
        .alert(isPresented: $showingDeleteAlert) {
            deleteAlert
        }
        .sheet(isPresented: $showingEditProductSheet) {
            editProductForm
        }
        .sheet(isPresented: $showingDiscountProductSheet) {
            discountProductForm
        }
        .sheet(isPresented: $showingAddToCartSheet) {
            addToCartForm
        }
    }
    
    var deleteAlert: Alert {
        Alert(
            title: Text("Confirm Delete"),
            message: Text("Are you sure you want to delete this product?"),
            primaryButton: .destructive(Text("Delete")) {
                print("delete alert")
                let success = stock.remove_product(product)
                if !success {
                    print("Error unable to delete")
                } else {
                    print("Remove success")
                }
            },
            secondaryButton: .cancel()
        )
    }
    
    var editProductForm: some View {
        VStack {
            TextField("Product Name", text: $nameString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Product Price", text: $priceString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text(message)
            HStack(spacing: 10) {
                Button("Cancel") {
                    message = ""
                    showingEditProductSheet = false
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                Button("Edit Product") {
                    let success = stock.update_product(orig: product, new: Product(name: nameString, price: priceString))
                    if !success {
                        message = "The product name need to be unique."
                    } else {
                        message = ""
                        showingEditProductSheet = false
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    var discountProductForm: some View {
        VStack {
            TextField("Discount Percent", text: $discountPercentString)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack(spacing: 10) {
                Button("Cancel") {
                    showingDiscountProductSheet = false
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Apply Discount") {
                    if let discount = Double(discountPercentString) {
                        product.discount_percent = discount
                        showingDiscountProductSheet = false
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    var addToCartForm: some View {
        VStack {
            TextField("Amount", text: $amountString)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack(spacing: 10) {
                Button("Cancel") {
                    showingAddToCartSheet = false
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Add to cart") {
                    if let amount = Int(amountString) {
                        let order = Order(product: product, amount: amount)
                        bill.add_order(order)
                        showingAddToCartSheet = false
                        navigateToBillView = true
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
