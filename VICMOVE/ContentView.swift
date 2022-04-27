//
//  ContentView.swift
//  VICMOVE
//
//  Created by BeyonderLuu on 12/04/2022.

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = WebViewModel(link: "https://app.vicmove.com/", running: false)
    
    var body: some View {
        NavigationView {
            ZStack {
                SwiftUIWebView(viewModel: model)
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea([.bottom])
                
                NavigationLink(destination: Running(), isActive: $model.running) {
                    EmptyView()
                }.hidden()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
