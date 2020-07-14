//
//  AppContentView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/17/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI
import Firebase

struct AppRootView: View {
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var categoryData: categoryData
    var body: some View {
        Group{
            if Auth.auth().currentUser != nil || viewRouter.currentPage == "main"{
                MainView(viewRouter: viewRouter)
            }else if viewRouter.currentPage == "launch"{
               LaunchView(viewRouter: viewRouter)
            }else if viewRouter.currentPage == "login"{
                LoginView(viewRouter: viewRouter)
            }else if viewRouter.currentPage == "signup"{
                SignUpView(viewRouter: viewRouter)
            }
        }
    }
    private func updateData(){
        self.categoryData.getUserCategories()
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView(viewRouter: ViewRouter())
    }
}
