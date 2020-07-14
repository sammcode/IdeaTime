//
//  HomeView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/18/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

struct HomeView: View {
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var categoryData: categoryData
    @State private var showModal:Bool = false
    @State var showComposePopUp: Bool = false
    @State var title: String = "Home"
    @State private var searchText: String = ""
    @State private var showCancelButton: Bool = false
    @State var showLoading: Bool = false
    @State var reload: String = ""
    var body: some View {
        LoadingView(isShowing: $showLoading){
        NavigationView{
            ZStack{
            VStack{
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if self.showCancelButton  {
                        Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }else{
                        Button(action: {
                            withAnimation(){
                                self.showComposePopUp.toggle()
                            }
                        }){
                            Text("Compose")
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width/2.5, height: 35)
                                .background(Color("darkgray"))
                                .foregroundColor(Color("textcolor"))
                                .cornerRadius(10)
                                .padding(6)
                        }
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(self.showCancelButton)
                if allthoughts == []{
                    Text("Tap 'Compose' to add your first thought!")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.black)
                }
                List{
                    ForEach(allthoughts.filter{$0.content.hasKeywords(text: self.searchText) || self.searchText == ""}, id:\.id) {
                        thought in
                        ThoughtView(thought: thought)
                    }
                }
                .resignKeyboardOnDragGesture()
            }.composeToast(isShowing: self.$showComposePopUp)
                .navigationBarTitle(self.showComposePopUp ? "New Thought" : "Home")
                .navigationBarItems(leading: (
                    HStack{
                        Text(userName)
                            .font(.headline)
                            .fontWeight(.heavy)
                    }
                    ), trailing: (
                Button(action: {
                    withAnimation {
                        do{
                            try Auth.auth().signOut()
                            allthoughts = [Thought]()
                            self.viewRouter.currentPage = "launch"
                            print("Sign out success")
                        }catch let err {
                                print(err)
                        }
                    }
                }) {
                    HStack{
                        Text("Sign out")
                        .font(.headline)
                            .fontWeight(.heavy)
                        Image(systemName: "person.badge.minus.fill")
                        .imageScale(.large)
                    }
                }))
            
            }.onAppear(perform: self.updateData)
            
        
            }.navigationViewStyle(StackNavigationViewStyle())
    }
    }
    private func updateData(){
        showLoading = true
        getUserDocuments()
        getUserCategories()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {timer in
            if !loading{
                self.showLoading.toggle()
                timer.invalidate()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            self.reload = "reload"
        }
    }
    private func toggleLoading(){
        showLoading.toggle()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewRouter: ViewRouter()).environmentObject(categoryData())
    }
}

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
                            .frame(width: 190, height: 40)
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
                            .frame(width: 190, height: 40)
                            .foregroundColor(Color("textcolor"))
                            .background(Color("darkgray"))
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

extension View {

    func composeToast(isShowing: Binding<Bool>) -> some View {
        ComposePopUp( isShowing: isShowing,
                      presenting: { self }, data: Data())
    }

}
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight - 32)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
extension String {
    func hasKeywords(text: String) -> Bool{
        guard text != "" else {
            return false
        }
        let inputWords = text.wordList
       
        
        for word in inputWords{
            if self.range(of: word, options: .caseInsensitive) != nil {
                // match
                return true
            } else {
                return false
            }
        }
        return false
        
    }
}
