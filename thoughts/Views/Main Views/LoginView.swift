//
//  LoginView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errMessage: String = ""
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView{
            Background{
            ZStack{
                Colors.lighterblue.edgesIgnoringSafeArea(.all)
            VStack{
                VStack {
                    TextField("Email", text: self.$email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                        .padding(.trailing)
                        .textContentType(.password)
                        
                    .frame(width: UIScreen.main.bounds.width/1.2, height: 10)
                    .padding(.bottom, 30)
                   
                }
                VStack {
                    SecureField("Password", text: self.$password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                        .padding(.trailing)
                        .textContentType(.password)
                        
                        .frame(width: UIScreen.main.bounds.width/1.2, height: 10)
                        .padding(.bottom, 30)
                }
                Button(action:{
                    self.viewRouter.currentPage = "signup"
                }){
                    Text("Don't have an account? Sign up here.")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundColor(Colors.chillblue)
                }
                VStack {
                    Button(action: {
                        self.endEditing()
                        //Validate Text Fields
                        
                        //Create cleaned versions of the text field
                        let cleanedEmail = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
                        let cleanedPassword = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
                        //Signing in the user
                        Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { (result, error) in
                            
                            if error != nil{
                                //Couldn't sign in
                                self.errMessage = error!.localizedDescription
                            }else{
                                //Sign in success
                                self.viewRouter.currentPage = "main"
                            }
                        }
                    }) {
                        Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width/1.2, height: 50) .background(Colors.niceblue)
                        .foregroundColor(Color.white)
                        .cornerRadius(50)
                        .shadow(radius: 5)
                        
                    }
                    .padding(.top)
                    Text(self.errMessage)
                    .foregroundColor(Color.red)
                    .font(.subheadline)
                    .padding(.top)
                    .lineLimit(nil)
                }
            }
            .navigationBarTitle("Login")
            }
        }.onTapGesture(perform: endEditing)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewRouter: ViewRouter())
    }
}
