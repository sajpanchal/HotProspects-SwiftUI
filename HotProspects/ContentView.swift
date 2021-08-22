//
//  ContentView.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var user = User()
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .onTapGesture {
                    self.selectedTab = 1
                }
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
                }
                .tag(0)
            Text("Tab 2")
               
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
                .tag(1)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
