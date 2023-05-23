//
//  CheckoutView.swift
//  Arbuz
//
//  Created by Tore Amangeldy on 5/23/23.
//


import SwiftUI

struct CheckoutView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    // Add a new @State variable for form validation
    @State private var isFormValid: Bool = false
    @State private var phoneNumberErrorMessage: String = ""
    @State private var floorErrorMessage: String = ""
    @State private var errorMessage: String = ""
    
    @State private var selectedProducts: [String] = []
    @State private var deliveryDay: Int = 1
    @State private var deliveryPeriod = ""
    @State private var phoneNumber: String = ""
    @State private var subscriptionPeriod: Int = 1
    @State private var outOfStock: Bool = false
    @State private var selectedDay = "Понедельник"
    
    @State private var deliveryAddressCity: String = ""
    @State private var deliveryAddressStreet: String = ""
    @State private var deliveryAddressApartment: String = ""
    @State private var deliveryAddressFloor: String = ""
    @State private var deliveryAddressEntrance: String = ""
    
    @State private var cityErrorMessage: String = ""
    @State private var streetErrorMessage: String = ""
    @State private var apartmentErrorMessage: String = ""
    @State private var entranceErrorMessage: String = ""
    
    let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    let periodOfTimes = ["7:00-9:00","8:00-10:00","9:00-11:00","10:00-12:00","11:00-13:00","12:00-14:00","13:00-15:00","14:00-16:00","15:00-17:00","16:00-18:00","17:00-19:00","18:00-20:00","19:00-21:00","20:00-22:00","21:00-23:00","22:00-00:00"]
    
    var body: some View {
        NavigationView {
            Form {
                // Delivery Details Section
                Section(header: Text("Детали доставки").foregroundColor(.green)) {
                    
                    Picker("День доставки", selection: $selectedDay) {
                        ForEach(daysOfWeek, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Период доставки", selection: $deliveryPeriod) {
                        Text("Не важно").tag("") //basically added empty tag and it solve the case
                        ForEach(periodOfTimes, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("Номер телефона", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .onChange(of: phoneNumber) { newValue in
                                if newValue.count > 11 {
                                    phoneNumber = String(newValue.prefix(11))
                                } else {
                                    phoneNumberErrorMessage = ""
                                }
                            }
                        Text(phoneNumberErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .listRowBackground(Color.green.opacity(0.1))
                
                // Delivery Address Section
                Section(header: Text("Адрес доставки").foregroundColor(.green)) {
                    
                    //                    TextField("Город", text: $deliveryAddressCity)
                    //                        .keyboardType(.default)
                    
                    VStack(alignment: .leading) {
                        TextField("Город", text: $deliveryAddressCity)
                            .keyboardType(.default)
                        Text(cityErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("Улица и номер дома", text: $deliveryAddressStreet)
                            .keyboardType(.default)
                        Text(streetErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        TextField("Квартира", text: $deliveryAddressApartment)
                            .keyboardType(.numberPad)
                        Text(apartmentErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("Подьезд", text: $deliveryAddressEntrance)
                            .keyboardType(.numberPad)
                        Text(entranceErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Этаж", text: $deliveryAddressFloor)
                        .keyboardType(.numberPad)
                        .onChange(of: deliveryAddressFloor) { newValue in
                            if newValue.count > 2 {
                                deliveryAddressFloor = String(newValue.prefix(2))
                            }
                        }
                    
                }
                .listRowBackground(Color.green.opacity(0.1))
                
                // Subscription Period Section
                Section(header: Text("Срок подписки").foregroundColor(.green)) {
                    
                    Picker("Срок подписки", selection: $subscriptionPeriod) {
                        ForEach(1..<13) { month in
                            Text("\(month) Месяц(ев)").tag(month)
                        }
                    }
                }
                .listRowBackground(Color.green.opacity(0.1))
                
                // Product Availability Section
                Section(header: Text("Наличие продуктов").foregroundColor(.green)) {
                    Toggle(isOn: $outOfStock) {
                        Text("Я понимаю, что выбранные продукты могут быть не в наличии")
                    }
                }
                .listRowBackground(Color.green.opacity(0.1))
                
                // Checkout Button
                Section {
                    ZStack {
                        Color.clear
                        HStack {
                            Spacer()
                            Button(action: {
                                validateForm()
                                if isFormValid {
                                    self.viewRouter.currentPage = "finish"
                                }
                            }) {
                                Text("Оформить заказ")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(15)
                                    .font(.title2)
                            }
                            Spacer()
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationBarTitle("Оформление заказа", displayMode: .inline)
            .navigationBarColor(.systemGreen)
        }
        
    }
    
    
    // Add a new function for form validation
    private func validateForm() {
        isFormValid = true
        phoneNumberErrorMessage = ""
        floorErrorMessage = ""
        cityErrorMessage = ""
        streetErrorMessage = ""
        apartmentErrorMessage = ""
        entranceErrorMessage = ""
        
        // Check phone number
        if phoneNumber.count == 0 {
            isFormValid = false
            phoneNumberErrorMessage = "Заполните поле"
            return
        }
        
        if deliveryAddressCity.count == 0 {
            isFormValid = false
            cityErrorMessage = "Заполните поле"
            return
        }
        
        if deliveryAddressStreet.count == 0 {
            isFormValid = false
            streetErrorMessage = "Заполните поле"
            return
        }
        
        if deliveryAddressApartment.count == 0 {
            isFormValid = false
            apartmentErrorMessage = "Заполните поле"
            return
        }
        
        if deliveryAddressEntrance.count == 0 {
            isFormValid = false
            entranceErrorMessage = "Заполните поле"
            return
        }
        
        
        // Check floor
        if deliveryAddressFloor.count == 0 {
            isFormValid = false
            floorErrorMessage = "Заполните поле"
            return
        }
        
        if (phoneNumber.count != 0 &&
            deliveryAddressCity.count != 0 &&
            deliveryAddressStreet.count != 0 &&
            deliveryAddressApartment.count != 0 &&
            deliveryAddressEntrance.count != 0 &&
            deliveryAddressFloor.count != 0
        ){
            isFormValid = true
        }
    }
}


// Here is the implementation for TextField validation extension
extension TextField {
    func validation(_ condition: Bool, message: String) -> some View {
        self.overlay(condition ? AnyView(self) : AnyView(HStack { Spacer(); Text(message).foregroundColor(.red)}))
    }
}

// An extension to change the color of the navigation bar
extension View {
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor?
    
    init(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}


struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
