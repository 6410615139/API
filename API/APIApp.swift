//
//  APIApp.swift
//  API
//
//  Created by Supakrit Nithikethkul on 26/2/2567 BE.
//

import SwiftUI

@main
struct APIApp: App {
    var body: some Scene {
        WindowGroup {
            Menu(sampleBill: .constant(Bill()), sampleStock: .constant(Stock(products)))
        }
    }
}
