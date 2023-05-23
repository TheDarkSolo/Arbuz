//
//  ContentView.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//
//

import SwiftUI


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


struct MainView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            VStack {
                if viewRouter.currentPage == "content" {
                    ContentView(basketItems: $viewRouter.basketItems)
                        .environmentObject(viewRouter)
                        .transition(.opacity) // Apply fade animation
                } else if viewRouter.currentPage == "checkout" {
                    CheckoutView()
                        .environmentObject(viewRouter)
                        .transition(.opacity) // Apply fade animation
                } else if viewRouter.currentPage == "finish" {
                    FinishView()
                        .environmentObject(viewRouter)
                        .transition(.opacity) // Apply fade animation
                }
            }
        }
        .animation(.easeInOut(duration: 99.5), value: 50) // Apply animation to the entire view
        .navigationBarHidden(true)
    }
}

struct ContentView: View {

    @ObservedObject var productsViewModel = ProductsViewModel()
    @Binding var basketItems: [Product]
    
    @EnvironmentObject var viewRouter: ViewRouter

    
    var body: some View {
        NavigationView {
                VStack {
                    
                    Text("Подписка")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.top)
                        
                    ScrollView {
                    Text("Добро пожаловать в Arbuz! Выберите свежие продукты для еженедельной доставки.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.bottom)
                    
                    GridView(columns: 2, list: $productsViewModel.products) { index in
                        ProductView(product: self.$productsViewModel.products[index])
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: BasketView(basketItems: $productsViewModel.products)) {
                    Text("Перейти в корзину")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                }
                 .padding()
            }
            .navigationBarHidden(true)
       
        
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
                    self.productsViewModel.fetchData()
                }
    }
}

struct ProductView: View {
    @Binding var product: Product
    
    var body: some View {
        VStack {
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(product.name)
                .font(.headline)
            HStack {
                Text(String(product.price) + "₸")
                    .font(.subheadline)
                Spacer()
                if product.quantity > 0 {
                    CustomStepper(quantity: $product.quantity)
               } else {
                    Button(action: { product.quantity = 1 }) {
                        Text("+")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct CustomStepper: View {
    @Binding var quantity: Int
    
    var body: some View {
        HStack {
            Button(action: {
                if quantity > 0 { quantity -= 1 }
            }) {
                Text("-")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 20, height: 24)
                    .background(Color.red)
                    .clipShape(Circle())
                    .opacity(0.7)
            }
            Spacer()
            Text("\(quantity)")
                .font(.title2)
                .foregroundColor(.black)
                .padding(.horizontal,-20)
            
            Button(action: {
                quantity += 1
            }) {
                Text("+")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 20, height: 24)
                    .background(Color.green)
                    .clipShape(Circle())
                    .opacity(0.7)
            }
        }
        .padding(.horizontal,5)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}



struct GridView<Content: View, T: Identifiable>: View {
    let columns: Int
    @Binding var list: [T]
    let content: (Int) -> Content

    private var gridLayout: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 20), count: columns)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 20) {
                ForEach(list.indices, id: \.self) { index in
                    content(index)
                }
            }
            .padding()
        }
    }
}
