//
//  DeletePopUp.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI
import Combine

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
