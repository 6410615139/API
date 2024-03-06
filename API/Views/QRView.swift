//
//  QRView.swift
//  API
//
//  Created by Supakrit Nithikethkul on 4/3/2567 BE.
//

import SwiftUI

struct QRView: View {
    @ObservedObject var bill: Bill
    
    var body: some View {
        Text("QRView")
        AsyncImage(url: URL(string: "https://promptpay.io/0656549690.png/\(bill.total_price)"))
                        .frame(width: 350, height: 350)
    }
}
