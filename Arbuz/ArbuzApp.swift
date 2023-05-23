//
//  ArbuzApp.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        print(db)
        
        
        let productsRef = db.collection("products")
        
        productsRef.document("smetana").setData([
            "name": "Сметана",
            "price": 600,
            "imageName":"smetana",
            "quantity": 0
        ])
        productsRef.document("malina").setData([
            "name": "Малина 1 кг",
            "price": 2000,
            "imageName":"malina",
            "quantity": 0
        ])
        productsRef.document("kukuruza").setData([
            "name": "Кукуруза 1 кг",
            "price": 600,
            "imageName":"kukuruza",
            "quantity": 0
        ])
        productsRef.document("arbuz").setData([
            "name": "Арбуз 1 кг",
            "price": 200,
            "imageName":"arbuz",
            "quantity": 0
        ])
        productsRef.document("banan").setData([
            "name": "Банан 1 кг",
            "price": 1000,
            "imageName":"banan",
            "quantity": 0
            
        ])
        productsRef.document("kola").setData([
            "name": "Кока-Кола",
            "price": 500,
            "imageName":"kola",
            "quantity": 0
            
        ])
        
        
//        let docRef = db.collection("products").document("banan")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }

        return true
    }
}

@main
struct ArbuzApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(viewRouter)
        }
    }
}


