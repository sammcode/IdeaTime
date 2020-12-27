//
//  CategoryView.swift
//  thoughts
//
//  Created by Sam McGarry on 1/12/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    var category: Category
    @EnvironmentObject var categoryData: categoryData
    @ObservedObject var viewRouter: ViewRouter
    @State var showDeletePopUp: Bool = false
    var body: some View {
        VStack{
            if category.name == "All Thoughts"{
                List{
                    ForEach(allthoughts, id:\.id) {
                        thought in
                        ThoughtView(thought: thought)
                    }
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).padding(.top, UIScreen.main.bounds.height/5)
            }else if category.name == "Favorites"{
                List{
                    ForEach(allthoughts.filter{$0.isFavorite == true}, id:\.id) {
                        thought in
                        ThoughtView(thought: thought)
                    }
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).padding(.top, UIScreen.main.bounds.height/5)
            }else{
                List{
                    ForEach(allthoughts.filter{$0.category == category.name}, id:\.id) {
                        thought in
                        ThoughtView(thought: thought)
                    }
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).padding(.top, UIScreen.main.bounds.height/5)
            }
        }.navigationBarTitle(Text(category.name), displayMode: .inline).navigationBarItems(trailing:
            Button(action: {
            withAnimation {
                if(self.category.name != "All Thoughts" && self.category.name != "Favorites"){
                    self.showDeletePopUp.toggle()
                }
            }
        }){
            Image(systemName: "trash").resizable()
                .frame(width:25, height:25)
                .foregroundColor(Color.red)
        })
            .onDisappear(perform: clearData)
            .delCatToast(isShowing: $showDeletePopUp, category: self.category)
    }
    
    private func clearData(){
        categoryThoughts = [Thought]()
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: Category1, viewRouter: ViewRouter()).environmentObject(categoryData())
    }
}
