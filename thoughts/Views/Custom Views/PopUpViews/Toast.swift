//
//  Toast.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI
import Combine

struct Toast<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    @State private var text: String = ""
    @EnvironmentObject var categoryData: categoryData
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        
        GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    TextField("Category Name", text: self.$text)
                        .padding(.leading)
                        .padding(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 250, height: 40)
                        .padding(.bottom, 10)
                        .foregroundColor(Colors.darkgray)
                    Button(action: {
                        self.text = ""
                        UIApplication.shared.endEditing()
                        self.isShowing = false
                    }){
                        Text("Cancel")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .padding()
                            .frame(width: 200, height: 30) .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                    }
                    Button(action:{
                        withAnimation{
                            var alreadyExists = false
                            for cat in categories{
                                if cat.name == self.text{
                                    alreadyExists = true
                                    print("already exists!")
                                }
                            }
                            self.categoryData.createCategory(categoryName: self.text, alreadyExists: alreadyExists)
                            self.text = ""
                            UIApplication.shared.endEditing(true)
                            self.isShowing = false
                        }
                    }){
                        Text("Create Category")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .padding()
                            .frame(width: 200, height: 30)
                            .background(Colors.darkgray)
                            .foregroundColor(Colors.textcolor)
                            .cornerRadius(10)
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
                    .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }
}
