//
//  DeleteCategoryPopUp.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI
import Combine

struct DeleteCategoryPopUp<Presenting>: View where
    
    Presenting: View {
    var category: Category
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    @EnvironmentObject var categoryData: categoryData
    var body: some View {
        
        GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Are you sure you want to delete this category? (This will not delete the thoughts within it.)")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.black)
                        .padding(.bottom, 30)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 300, height: 40)
                       
                    HStack{
                        Button(action:{
                            withAnimation{
                                self.isShowing = false
                            }
                            
                        }){
                            Text("Cancel")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .padding()
                                .frame(width: 140, height: 30) .background(Color.gray)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                            
                        }
                        
                        Button(action:{
                            withAnimation{
                                self.categoryData.deleteCategory(categoryID: self.category.id)
                                currentCategory = self.category
                                for thought in allthoughts{
                                    if thought.category == self.category.name{
                                        updateCategoryField(category: "", docID: thought.id)
                                    }
                                }
                                self.isShowing = false
                                
                            }
                        }){
                            Text("Delete")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .padding()
                                .frame(width: 140, height: 30) .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }
                    }.padding(.top, 10)
                }.padding()
                .frame(width: geometry.size.width ,
                       height: geometry.size.height )
                    .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }
}
