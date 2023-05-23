//
//  FinishView.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//

import SwiftUI

//struct FinishView_Previews: PreviewProvider {
//    static var previews: some View {
//        FinishView()
//    }
//}

struct FinishView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var navigateToContentView = false
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("Вы подписаны!")
                .font(.title)
                .foregroundColor(.green)
                .padding()
                .multilineTextAlignment(.center)
            
            Text("Спасибо, что выбрали Arbuz!")
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            Button(action: {
                withAnimation {
                    navigateToContentView = true
                }
                
            }) {
                Text("Вернуться домой")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .fullScreenCover(isPresented: $navigateToContentView) {
            ContentView(basketItems: $viewRouter.basketItems)
        }
    }
}


