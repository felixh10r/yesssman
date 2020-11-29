//
//  ContentView.swift
//  yesssman
//
//  Created by Felix on 21.12.19.
//  Copyright © 2019 scale. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    @ObservedObject var resource = YesssResource()
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Phone number", text: $phoneNumber)
                SecureField("Password", text: $password)
                Button(action: {
                    UserDefaults(suiteName: "group.at.scale.yesssman")!.set(phoneNumber, forKey: "phoneNumber")
                    UserDefaults(suiteName: "group.at.scale.yesssman")!.set(password, forKey: "password")
                }) {
                    Text("Login")
                }
            }
            .navigationBarTitle("Login")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
