//
//  BasketView.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//

import SwiftUI

//struct BasketView_Previews: PreviewProvider {
//    static var previews: some View {
//        BasketView()
//    }
//}

struct BasketView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var basketItems: [Product]
    @State private var navigateToCheckoutView = false
    
    var totalPrice: Int {
        basketItems.reduce(0) { total, product in
            total + product.price * product.quantity
        }
    }
    
    var body: some View {
        VStack {
            Text("Ваша корзина")
            
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding()
            
            List {
                ForEach(basketItems.filter { $0.quantity > 0 }) { product in
                    HStack {
                        Image(product.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(product.name)
                        Spacer()
                        Text("\(product.quantity) x \(String(product.price))" + "₸")
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    navigateToCheckoutView = true
                }
                //            self.viewRouter.currentPage = "checkout"
            }) {
                VStack {
                    Text("Перейти к оплате")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(String(totalPrice) + "₸")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                }
                .padding()
                .background(Color.green)
                .cornerRadius(15)
            }
            
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToCheckoutView) {
            CheckoutView()
        }
    }
}


