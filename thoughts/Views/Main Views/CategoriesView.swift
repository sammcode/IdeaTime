//
//  CategoriesView.swift
//  thoughts
//
//  Created by Sam McGarry on 1/7/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct CategoriesView: View {
    @State var showToast: Bool = false
    @EnvironmentObject var categoryData: categoryData
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView {
            //Background{
                VStack{
                    List{
                        ForEach(self.categoryData.categories){ category in
                            
                            VStack{
                                NavigationLink(destination: CategoryView(category: category, viewRouter: ViewRouter()).environmentObject(self.categoryData)){
                                    CategoryCardView(
                                        category: category
                                    )
                                }
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.3)
                .navigationBarTitle("Categories").navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        self.showToast.toggle()
                        //self.viewRouter.currentPage = "launch"
                    }
                }){
                    Image(systemName: "folder.fill.badge.plus").resizable()
                        .frame(width: 40, height: 28)
                })
            //}.onTapGesture(perform: endEditing)
        }.toast(isShowing: self.$showToast).onAppear(perform: updateData).navigationViewStyle(StackNavigationViewStyle())
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
        showToast = false
    }
    private func updateData(){
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            if currentCategory.name != ""{
                self.categoryData.getUserCategories()
                currentCategory = Category1
            }
        }
        
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(viewRouter: ViewRouter()).environmentObject(categoryData())
    }
}
