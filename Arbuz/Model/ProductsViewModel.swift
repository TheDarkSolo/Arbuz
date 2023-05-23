//
//  ProductsViewModel.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Product: Identifiable, Hashable {
    var id: String
    var name: String
    var price: Int
    var imageName: String
    var quantity: Int
}

class ProductsViewModel: ObservableObject {
    private var db = Firestore.firestore()

    @Published var products = [Product]()

    func fetchData() {
        db.collection("products").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.products = querySnapshot?.documents.compactMap { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    guard let name = data["name"] as? String,
                          let price = data["price"] as? Int,
                          let imageName = data["imageName"] as? String,
                          let quantity = data["quantity"] as? Int else {
                        print("Document does not have necessary fields.")
                        return nil
                    }
                   // print("Product fetched: \(name), \(price), \(imageName), \(quantity)")
                    return Product(id: queryDocumentSnapshot.documentID, name: name, price: price, imageName: imageName, quantity: quantity)
                } ?? []
                //print("Total products fetched: \(self.products.count)")
            }
        }
    }
}
//
//struct Product: Identifiable, Hashable {
//    let id: UUID
//    let name: String
//    let price: Int
//    let imageName: String
//    var quantity: Int
//
//    static func == (lhs: Product, rhs: Product) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//class ProductsViewModel: ObservableObject {
//    @Published var products: [Product] = [
//        Product(id: UUID(), name: "Сметана", price: 600, imageName: "smetana", quantity: 0),
//        Product(id: UUID(), name: "Малина 1 кг", price: 2000, imageName: "malina", quantity: 0),
//        Product(id: UUID(), name: "Кукуруза 1 кг", price: 600, imageName: "kukuruza", quantity: 0),
//        Product(id: UUID(), name: "Арбуз 1 кг", price: 200, imageName: "arbuz", quantity: 0),
//        Product(id: UUID(), name: "Банан 1 кг", price: 1000, imageName: "banan", quantity: 0),
//        Product(id: UUID(), name: "Кока-Кола", price: 500, imageName: "kola", quantity: 0),
//        // можно добавить больше
//    ]
//}
//
//
