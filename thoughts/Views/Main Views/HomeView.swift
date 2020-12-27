//
//  HomeView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/18/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

struct HomeView: View {
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var categoryData: categoryData
    @State private var showModal:Bool = false
    @State var showComposePopUp: Bool = false
    @State var title: String = "Home"
    @State private var searchText: String = ""
    @State private var showCancelButton: Bool = false
    @State var showLoading: Bool = false
    @State var reload: String = ""
    var body: some View {
        LoadingView(isShowing: $showLoading){
        NavigationView{
            ZStack{
            VStack{
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if self.showCancelButton  {
                        Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }else{
                        Button(action: {
                            withAnimation(){
                                self.showComposePopUp.toggle()
                            }
                        }){
                            Text("Compose")
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width/2.5, height: 35)
                                .background(Colors.darkgray)
                                .foregroundColor(Colors.textcolor)
                                .cornerRadius(10)
                                .padding(6)
                        }
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(self.showCancelButton)
                if allthoughts == []{
                    Text("Tap 'Compose' to add your first thought!")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.black)
                }
                List{
                    ForEach(allthoughts.filter{$0.content.hasKeywords(text: self.searchText) || self.searchText == ""}, id:\.id) {
                        thought in
                        ThoughtView(thought: thought)
                    }
                }
                .resignKeyboardOnDragGesture()
            }.composeToast(isShowing: self.$showComposePopUp)
                .navigationBarTitle(self.showComposePopUp ? "New Thought" : "Home")
                .navigationBarItems(leading: (
                    HStack{
                        Text(userName)
                            .font(.headline)
                            .fontWeight(.heavy)
                    }
                    ), trailing: (
                Button(action: {
                    withAnimation {
                        do{
                            try Auth.auth().signOut()
                            allthoughts = [Thought]()
                            self.viewRouter.currentPage = "launch"
                            print("Sign out success")
                        }catch let err {
                                print(err)
                        }
                    }
                }) {
                    HStack{
                        Text("Sign out")
                        .font(.headline)
                            .fontWeight(.heavy)
                        Image(systemName: "person.badge.minus.fill")
                        .imageScale(.large)
                    }
                }))
            
            }.onAppear(perform: self.updateData)
            
        
            }.navigationViewStyle(StackNavigationViewStyle())
    }
    }
    private func updateData(){
        showLoading = true
        getUserDocuments()
        getUserCategories()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {timer in
            if !loading{
                self.showLoading.toggle()
                timer.invalidate()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            self.reload = "reload"
        }
    }
    private func toggleLoading(){
        showLoading.toggle()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewRouter: ViewRouter()).environmentObject(categoryData())
    }
}
