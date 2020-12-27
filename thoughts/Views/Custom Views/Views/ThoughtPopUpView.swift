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
                            .background(Colors.darkgray)
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
                            .background(Colors.darkgray)
                            .foregroundColor(Colors.textcolor)
                            .cornerRadius(5)
                    }
                    Button(action: {
                        withAnimation{
                            self.showDeletePopUp.toggle()
                        }
                    }){
                        Image(systemName: "trash")
                            .frame(width: geometry.size.width / 3.35, height: 35)
                            .background(Colors.darkgray)
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
            return (thought.isFavorite ? Color.yellow : Colors.textcolor)
        }
        else{
            if thought.isFavorite == true{
                return (didTap ? Colors.textcolor : Color.yellow)
            }else{
                return (didTap ? Color.yellow: Colors.textcolor)
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
