//
//  SignUpView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordAgain: String = ""
    @State private var errMessage: String = ""
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    var body: some View {
        NavigationView{
            Background{
                ZStack{
                    Colors.lighterblue.edgesIgnoringSafeArea(.all)
                    VStack{
                        VStack {
                            TextField("Name", text: self.$name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                                .padding(.trailing)
                                
                                .frame(width: UIScreen.main.bounds.width/1.2, height: 3)
                                .padding(.bottom, 30)
                            
                            TextField("Email", text: self.$email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                                .padding(.trailing)
                                
                                .frame(width: UIScreen.main.bounds.width/1.2, height: 3)
                                .padding(.bottom, 30)
                            
                            SecureField("Password", text: self.$password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                                .padding(.trailing)
                                .textContentType(.password)
                                
                                
                                .frame(width: UIScreen.main.bounds.width/1.2, height: 3)
                                .padding(.bottom, 30)
                            
                            SecureField("Re-Enter Password", text: self.$passwordAgain)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                                .padding(.trailing)
                                .textContentType(.password)
                                
                                .frame(width: UIScreen.main.bounds.width/1.2, height: 3)
                                .padding(.bottom, 30)
                                .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
                            Button(action:{
                                self.viewRouter.currentPage = "login"
                            }){
                                Text("Already have an account? Login here.")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .foregroundColor(Colors.chillblue)
                            }
                        }
                        
                        Button(action: {
                            // Your auth logic
                            let error = validateFields(email: self.email, password: self.password, passwordAgain: self.passwordAgain)
                            if error != nil {
                                //Something is wrong with the fields
                                self.errMessage = error!
                            }
                            else{
                                //Create user
                                Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, err) in
                                    if err != nil{
                                        self.errMessage = "Error creating user"
                                    }else{
                                        let cleanedEmail = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
                                        let cleanedPassword = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
                                        Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { (result, error) in
                                            
                                            if error != nil{
                                                //Couldn't sign in
                                                self.errMessage = error!.localizedDescription
                                            }else{
                                                //Sign in success
                                                let cUser = Firebase.Auth.auth().currentUser
                                                let db = Firestore.firestore()
                                                db.collection("users").document(cUser!.uid).setData(["userID": cUser!.uid, "name": self.name])
                                                
                                                db.collection("users").document(cUser!.uid).collection("categories")
                                                db.collection("users").document(cUser!.uid).collection("All Thoughts")
                                                
                                                self.viewRouter.currentPage = "main"
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }) {
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .font(.title)
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
                    }.offset(y: self.kGuardian.slide).animation(.easeInOut(duration: 0.4))
                }
            }.onTapGesture(perform: endEditing)
                .navigationBarTitle("Sign Up")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewRouter: ViewRouter())
    }
}

func validateFields(email: String, password: String, passwordAgain: String) -> String? {
    if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordAgain.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        return "Please fill in all fields."
    }
    let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
    let cleanedPasswordAgain = password.trimmingCharacters(in: .whitespacesAndNewlines)
    if isPasswordVaild(password) == false{
        //Password isn't secure enough
        return "Please make sure your password is atleast 8 characters, contains a special character and a number."
    }
    if cleanedPassword != cleanedPasswordAgain{
        //Passwords don't match
        return "Passwords don't match."
    }
    return nil
}

func isPasswordVaild(_ password: String) -> Bool {
    
    let paswordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return paswordTest.evaluate(with: password)
}

func createNewUser(email: String, password: String) -> String{
    
    var errMessage: String = ""
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        if err != nil{
            errMessage = "Error creating user"
        }else{
            let cUser = Firebase.Auth.auth().currentUser
            let db = Firestore.firestore()
            db.collection("users").document(cUser!.uid).setData(["userID": cUser!.uid])
            db.collection("users").document(cUser!.uid).collection("categories")
            db.collection("users").document(cUser!.uid).collection("allThoughts")
            db.collection("users").document(cUser!.uid).collection("favoriteThoughts")
            
                let newCategory =  db.collection("users").document(cUser!.uid).collection("categories").document()
                newCategory.setData(["id":newCategory.documentID, "name": "All Thoughts"])
                
                let newCategory1 =  db.collection("users").document(cUser!.uid).collection("categories").document()
                newCategory1.setData(["id":newCategory1.documentID, "name": "Favorites"])
        }
    }
    return errMessage
}


