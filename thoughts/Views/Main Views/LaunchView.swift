//
//  LaunchView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/17/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI



struct LaunchView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        ZStack{
            Color("lighterblue").edgesIgnoringSafeArea(.all)
        VStack{
            Text("Thought Matter")
                .font(.system(size: 90))
                .fontWeight(.heavy)
                .foregroundColor(Color.white)
                .padding(.bottom, 40)
                .padding(.top, 40)
                .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height/1.5)
                
                
            Spacer()
            Button(action: {
                self.viewRouter.currentPage = "login"
            }) {
                Text("Log In")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    
                .frame(width: UIScreen.main.bounds.width/1.2, height: 50) .background(Color("niceblue"))
                .foregroundColor(Color.white)
                .cornerRadius(50)
                .shadow(radius: 5)
            }
            .padding()
            Button(action: {
                self.viewRouter.currentPage = "signup"
            }) {
                Text("Sign Up")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    
                    .frame(width: UIScreen.main.bounds.width/1.2, height: 50) .background(Color("niceblue"))
                .foregroundColor(Color.white)
                .cornerRadius(50)
                .shadow(radius: 5)
            }
            .padding(.bottom)
        }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(viewRouter: ViewRouter())
    }
}
