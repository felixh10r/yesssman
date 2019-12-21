//
//  ContentView.swift
//  yesssman
//
//  Created by Felix on 21.12.19.
//  Copyright © 2019 scale. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var resource = YesssResource()

    var body: some View {
        VStack {
            if resource.data != nil {
                Text("\(resource.data!.free) / \(resource.data!.total)")
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(
            Color("primary")
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
