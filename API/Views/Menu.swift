//
//  Menu.swift
//  API
//
//  Created by Supakrit Nithikethkul on 2/3/2567 BE.
//

import SwiftUI

struct Menu: View {
    @Binding var sampleBill: Bill
    @State private var products: [Product] = [
        Product(name: "Product 1", price: 9.99),
        Product(name: "Product 2", price: 19.99),
        Product(name: "Product 3", price: 29.99),
    ]
    
    @State private var showingAddProductSheet = false
    @State private var newProductName = ""
    @State private var newProductPrice = ""
    
    @State private var showingDeleteAlert = false
    @State private var productToDelete: Product?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(products, id: \.name) { product in
                        ProductRow(product: product, bill: $sampleBill) {
                            productToDelete = product
                            showingDeleteAlert = true
                        }
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
            .alert(isPresented: $showingDeleteAlert) {
                deleteAlert
            }
        }
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
            
            HStack(spacing: 10) { // Added spacing for a little space between buttons
               Button("Cancel") {
                   // Dismiss the sheet
                   showingAddProductSheet = false
               }
               .padding()
               .background(Color.gray)
               .foregroundColor(.white)
               .cornerRadius(10)

               Button("Add Product") {
                   if let price = Double(newProductPrice), !newProductName.isEmpty {
                       let newProduct = Product(name: newProductName, price: price)
                       products.append(newProduct)
                       showingAddProductSheet = false
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

    var deleteAlert: Alert {
        Alert(
            title: Text("Confirm Delete"),
            message: Text("Are you sure you want to delete this product?"),
            primaryButton: .destructive(Text("Delete")) {
                if let product = productToDelete, let index = products.firstIndex(where: { $0.name == product.name }) {
                    products.remove(at: index)
                }
            },
            secondaryButton: .cancel()
        )
    }
}

struct ProductRow: View {
    var product: Product
    @Binding var bill: Bill
    var onDelete: () -> Void  // Closure to call when delete is triggered

    var body: some View {
        NavigationLink(destination: ProductView(product: product)) {
            HStack {
                Text(product.name)
                    .font(.title)
                Spacer()
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .padding(.leading, 8)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(sampleBill: .constant(Bill()))
    }
}
