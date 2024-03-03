//
//  ProductView.swift
//  API
//
//  Created by Supakrit Nithikethkul on 3/3/2567 BE.
//

import SwiftUI

struct ProductView: View {
    @Binding var product: Product
    @ObservedObject var stock: Stock
    @Binding var bill: Bill
    
    @State private var showingEditProductSheet = false
    @State private var showingDiscountProductSheet = false
    
    @State private var showingDeleteAlert = false
    @State private var showingEditAlert = false
    
    @State private var nameString: String
    @State private var priceString: String
    @State private var discountPercentString: String = "0"

    init(product: Binding<Product>, stock: Stock, bill: Binding<Bill>) {
            _product = product
            _stock = ObservedObject(initialValue: stock)
            _bill = bill
            _nameString = State(initialValue: product.wrappedValue.name)
            _priceString = State(initialValue: "\(product.wrappedValue.price)")
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
                Text("Discounted \(product.discount_percent, specifier: "%.2f")%: \(discountedPrice, specifier: "%.2f")฿")
                    .font(.title3)
                    .foregroundColor(.red)
            }

            HStack(spacing: 7) {
                Button(action: {
                    self.showingDeleteAlert = true
                }) {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Button(action: {
                    self.showingEditProductSheet = true
                }) {
                    Label("Edit", systemImage: "pencil")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    self.showingDiscountProductSheet = true
                }) {
                    Label("Discount", systemImage: "percent")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
        .alert(isPresented: $showingDeleteAlert) {
            deleteAlert
        }
        .alert(isPresented: $showingEditAlert) {
            updateAlert
        }
        .sheet(isPresented: $showingEditProductSheet) {
            editProductForm
        }
        .sheet(isPresented: $showingDiscountProductSheet) {
            discountProductForm
        }
    }
    
    var deleteAlert: Alert {
        Alert(
            title: Text("Confirm Delete"),
            message: Text("Are you sure you want to delete this product?"),
            primaryButton: .destructive(Text("Delete")) {
                _ = stock.remove_product(product)
            },
            secondaryButton: .cancel()
        )
    }
    
    var updateAlert: Alert {
        Alert(
            title: Text("Update error"),
            message: Text("The updated product name is not unique."),
            dismissButton: .cancel(Text("OK"))
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
            
            HStack(spacing: 10) {
                Button("Cancel") {
                    showingEditProductSheet = false
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Edit Product") {
                    let occur = stock.update_product(orig: product, new: Product(name: nameString, price: priceString))
                    if occur == false {
                        showingEditAlert = true
                    }
                    showingEditProductSheet = false
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
}
