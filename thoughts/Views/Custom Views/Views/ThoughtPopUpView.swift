//
//  ThoughtPopUpView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/23/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI
import Firebase

struct ThoughtPopUpView: View {
    var thought: Thought
    @State private var didTap: Bool = false
    @State var firstOcc = true
    @State var input: String = ""
    @State var isEditing = false
    @State var showDeletePopUp: Bool = false
    @State var showAddToPopUp: Bool = false
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                HStack(alignment: .top){
                    Button(action:{
                        toggleFavorite(thought: self.thought)
                        self.didTap.toggle()
                        self.firstOcc = false
                    }){
                        Image(systemName: "star.fill")
                            
                            .frame(width: geometry.size.width / 3.35, height: 35)
                            .background(Color("darkgray"))
                            .foregroundColor(self.buttonColor)
                            .cornerRadius(5)
                        
                    }
                    Button(action: {
                        withAnimation{
                            self.showAddToPopUp.toggle()
                        }
                    }){
                        Image(systemName: "folder.badge.plus")
                            
                            .frame(width: geometry.size.width / 3.35, height: 35)
                            .background(Color("darkgray"))
                            .foregroundColor(Color("textcolor"))
                            .cornerRadius(5)
                    }
                    Button(action: {
                        withAnimation{
                            self.showDeletePopUp.toggle()
                        }
                    }){
                        Image(systemName: "trash")
                            
                            .frame(width: geometry.size.width / 3.35, height: 35)
                            .background(Color("darkgray"))
                            .foregroundColor(Color.red)
                            .cornerRadius(5)
                    }
                }.padding(.top, 0)
                TextView(text: self.$input, isEditing: self.$isEditing)
                    .frame(width: geometry.size.width / 1.1, height: (self.isEditing ? geometry.size.height / 2 : geometry.size.height/1.1))
                    .border(Color.black, width: 5)
                    .cornerRadius(5)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 5)
                
                
                
                Spacer()
            }.deleteToast(isShowing: self.$showDeletePopUp, thought: self.thought)
                .addToToast(isShowing: self.$showAddToPopUp, thought: self.thought)
                .onAppear(perform: self.update).frame(width: geometry.size.width, height: geometry.size.height)
            
        }
        
        
    }
    var buttonColor: Color {
        if firstOcc{
            return (thought.isFavorite ? Color.yellow : Color("textcolor"))
        }
        else{
            if thought.isFavorite == true{
                return (didTap ? Color("textcolor") : Color.yellow)
            }else{
                return (didTap ? Color.yellow: Color("textcolor"))
            }
        }
    }
    
    private func update(){
        let originalContent: String = thought.content
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            if originalContent != self.input{
                updateContentField(content: self.input, docID: self.thought.id)
            }
        }
    }
}

struct ThoughtPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        ThoughtPopUpView(thought: Thought1)
    }
}
struct DeletePopUp<Presenting>: View where
    
    Presenting: View {
    var thought: Thought
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    @State private var text: String = ""

    var body: some View {
        
        GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Are you sure you want to delete this thought?")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.black)
                        .padding(.bottom, 30)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 250, height: 40)
                       
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
                                .frame(width: 100, height: 30) .background(Color.gray)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                            
                        }
                        
                        Button(action:{
                            withAnimation{
                                deleteThought(thought: self.thought)
                                self.isShowing = false
                            }
                        }){
                            Text("Delete")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .padding()
                                .frame(width: 100, height: 30) .background(Color.red)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }
                    }
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
extension View {

    func deleteToast(isShowing: Binding<Bool>, thought: Thought) -> some View {
        DeletePopUp(thought: thought, isShowing: isShowing,
              presenting: { self })
    }
    func addToToast(isShowing: Binding<Bool>, thought: Thought) -> some View {
        AddToPopUp(thought: thought, isShowing: isShowing,
            presenting: { self }).environmentObject(categoryData())
    }
}
