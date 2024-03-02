//
//  ProductView.swift
//  API
//
//  Created by Supakrit Nithikethkul on 3/3/2567 BE.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var product: Product
    
    var body: some View {
        Text("Product")
        Button(action: {} ) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        Button(action: {}) {
            Image(systemName: "pencil")
                .foregroundColor(.gray)
        }
        Button(action: {}) {
            Image(systemName: "percent")
                .foregroundColor(.green)
        }
    }
}

