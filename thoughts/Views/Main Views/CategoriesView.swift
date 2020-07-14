//
//  CategoriesView.swift
//  thoughts
//
//  Created by Sam McGarry on 1/7/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct CategoriesView: View {
    @State var showToast: Bool = false
    @EnvironmentObject var categoryData: categoryData
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        NavigationView {
            //Background{
                VStack{
                    List{
                        ForEach(self.categoryData.categories){ category in
                            
                            VStack{
                                NavigationLink(destination: CategoryView(category: category, viewRouter: ViewRouter()).environmentObject(self.categoryData)){
                                    CategoryCardView(
                                        category: category
                                    )
                                }
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.3)
                .navigationBarTitle("Categories").navigationBarItems(trailing: Button(action: {
                    withAnimation {
                        self.showToast.toggle()
                        //self.viewRouter.currentPage = "launch"
                    }
                }){
                    Image(systemName: "folder.fill.badge.plus").resizable()
                        .frame(width:50, height:35)
                })
            //}.onTapGesture(perform: endEditing)
        }.toast(isShowing: self.$showToast).onAppear(perform: updateData).navigationViewStyle(StackNavigationViewStyle())
    }
    private func endEditing() {
        UIApplication.shared.endEditing()
        showToast = false
    }
    private func updateData(){
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            if currentCategory.name != ""{
                self.categoryData.getUserCategories()
                currentCategory = Category1
            }
        }
        
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(viewRouter: ViewRouter()).environmentObject(categoryData())
    }
}
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
                        .foregroundColor(Color.white)
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
                            UIApplication.shared.endEditing()
                            self.isShowing = false
                        }
                    }){
                        Text("Create Category")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .padding()
                            .frame(width: 200, height: 30) .background(Color("darkgray"))
                            .foregroundColor(Color.white)
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
extension View {

    func toast(isShowing: Binding<Bool>) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self }, viewRouter: ViewRouter()).environmentObject(categoryData())
    }

}

struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
