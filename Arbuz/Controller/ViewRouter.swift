//
//  ViewController.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: String
    @Published var basketItems: [Product] = []
    @Published var shouldShowContentView = false
    
    init() {
        self.currentPage = "content"
    }
}
