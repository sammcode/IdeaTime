//
//  AddToPopUp.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//
import SwiftUI
import Combine

struct AddToPopUp<Presenting>: View where
    
    Presenting: View {
    var thought: Thought
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    @State private var text: String = ""
    @EnvironmentObject var categoryData: categoryData
    var body: some View {
        
        GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    List{
                        ForEach(categories, id:\.id){
                            category in
                            //categorySelector(isSelected: false, category: category)
                                
                            Button(action:{
                                selectedCategory.name = category.name
                                withAnimation{
                                    if selectedCategory.name != "All Thoughts"{
                                        if selectedCategory.name == "Favorites"{
                                            toggleFavorite(thought: self.thought)
                                        }else{
                                            updateCategoryField(category: selectedCategory.name, docID: self.thought.id)
                                        }
                                    }
                                    selectedCategory = Category1
                                    self.isShowing = false
                                }
                            }){
                                CategoryCardView(category: category)
                            }
                        }
                    }.cornerRadius(20)
                    HStack{
                        Button(action:{
                            withAnimation{
                                self.isShowing = false
                                selectedCategory = Category1
                            }
                            
                        }){
                            Text("Cancel")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .padding()
                                .frame(width: 200, height: 30) .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                            
                        }
                    }
                }.padding()
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
    private func updateData(){
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            if selectedCategory.name != "" {
                categories = [selectedCategory]
            }else{
                getUserCategories()
            }
        }
    }
}
