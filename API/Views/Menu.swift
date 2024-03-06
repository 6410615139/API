//
//  Menu.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import SwiftUI

var products: [Product] = [
    Product(name: "Product 1", price: 1),
    Product(name: "Product 2", price: 10.10),
    Product(name: "Product 3", price: 20),
]

struct Menu: View {
    @ObservedObject var sampleBill: Bill
    @ObservedObject var sampleStock: Stock
    
    @State private var showingAddProductSheet = false
    @State private var newProductName = ""
    @State private var newProductPrice = ""
    
    @State private var message = ""

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($sampleStock.container, id: \.name) { product in
                        ProductRow(product: product.wrappedValue, bill: sampleBill, stock: sampleStock)
                    }
                }
                NavigationLink(destination: BillView(bill: sampleBill)) {
                    Text("Go to Bill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Menu")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddProductSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProductSheet) {
                addProductForm
            }
        }
    }

    var addProductAlert: Alert {
        Alert(
            title: Text("Add product error"),
            message: Text("The added product name is not unique."),
            dismissButton: .cancel(Text("OK"))
        )
    }
    
    var addProductForm: some View {
        VStack {
            TextField("Product Name", text: $newProductName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Product Price", text: $newProductPrice)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            Text(message)
            HStack(spacing: 10) {
               Button("Cancel") {
                   showingAddProductSheet = false
                   message = ""
               }
               .padding()
               .background(Color.gray)
               .foregroundColor(.white)
               .cornerRadius(10)

                Button("Add Product") {
                    let newProduct = Product(name: newProductName, price: Double(newProductPrice) ?? 0.0)
                    let success = sampleStock.add_product(newProduct)
                    if !success {
                        message = "The product name need to be unique."
                    } else {
                        showingAddProductSheet = false
                        newProductName = ""
                        newProductPrice = ""
                        message = ""
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

struct ProductRow: View {
    @ObservedObject var product: Product
    @ObservedObject var bill: Bill
    @ObservedObject var stock: Stock

    var body: some View {
        NavigationLink(destination: ProductView(product: product, stock: stock, bill: bill)
            ) {
            VStack {
                HStack {
                    Text(product.name)
                        .font(.title)
                    Spacer()
                    Text("\(product.price, specifier: "%.2f")฿")
                        .font(.title3)
                        .strikethrough(product.discount_percent > 0.0, color: .red)
                        .foregroundColor(product.discount_percent > 0 ? .gray : .black)
                    }
                HStack {
                    if product.discount_percent > 0 {
                        let discountedPrice: Double = product.discount(percentage: product.discount_percent)
                        Text("-\(product.discount_percent, specifier: "%.2f")%")
                            .font(.footnote)
                            .foregroundColor(.red)
                        Spacer()
                        Text("\(discountedPrice, specifier: "%.2f")฿")
                            .font(.title3)
                            .foregroundColor(.red)
                }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(sampleBill: Bill(), sampleStock: Stock(products))
    }
}
