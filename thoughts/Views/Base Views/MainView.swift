//
//  ContentView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var categoryData: categoryData
    var body: some View {
        TabView(selection: $selection){
            HomeView(viewRouter: viewRouter)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            
            CategoriesView(viewRouter: ViewRouter())
            .tabItem {
                VStack{
                    Image(systemName: "folder.fill")
                    Text("Categories")
                }
            }.tag(1)
        }.onAppear(perform: updateData)
    }
    private func updateData(){
        self.categoryData.getUserCategories()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewRouter: ViewRouter())
    }
}
