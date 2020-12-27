//
//  ComposePopUp.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI
import Combine

struct ComposePopUp<Presenting>: View where
    
Presenting: View {
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    @State private var text: String = ""
    @State var input: String = ""
    @State var referredInput = ""
    @State private var isEditing = false
    @State var showCompToPopUp: Bool = false
    @State var compToOpened:Bool = false
    var data: Data
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                self.presenting()
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    HStack{
                        Button(action: {
                            withAnimation{
                                self.isEditing = false
                                self.isShowing = false
                                self.input = ""
                            }
                        }){
                            Text("Cancel")
                                .font(.headline)
                                .frame(width: geometry.size.width / 2.13, height: 40)
                                .foregroundColor(Color.white)
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding(.top, 5)
                        }
                        Button(action: {
                            if self.input != ""{ handlePostButton(content: self.input, isFavorite: false)
                                withAnimation{
                                    self.isEditing = false
                                    self.isShowing = false
                                    self.input = ""
                                }
                            }
                        }){
                            Text("Compose")
                                .font(.headline)
                                .frame(width: geometry.size.width / 2.13, height: 40)
                                .foregroundColor(Colors.textcolor)
                                .background(Colors.darkgray)
                                .cornerRadius(10)
                                .padding(.top, 5)
                        }
                        
                    }
                    TextView(text: self.$input, isEditing: self.$isShowing)
                        .border(Color.black, width: 5)
                        .cornerRadius(5)
                        .padding(.bottom, 5)
                        .frame(width: geometry.size.width / 1.05, height: geometry.size.height / 2)
                    
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height / 1.65)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .transition(.move(edge: .top))
                    .opacity(self.isShowing ? 1 : 0)
                    .KeyboardAwarePadding()
                
            }
        }
    }
}
