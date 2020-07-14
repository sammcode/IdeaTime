//
//  Data.swift
//  thoughts
//
//  Created by Sam McGarry on 12/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import Foundation
import Firebase
import Combine
import SwiftUI

var Thought1: Thought = Thought(id: "01", content: "Test Thought 123", dateCreated: "18.03.2020", refDate: "18.03.2020", isFavorite: false, category: "")
var thoughts1: [Thought] = [Thought1]
var Category1: Category = Category(id: "14", name: "")
var selectedCategories: [Category] = [Category]()
var selectedCategory: Category = Category(id: "15", name: "")
var allthoughts: [Thought] = [Thought]()
var categoryThoughts: [Thought] = [Thought]()
let db = Firestore.firestore()
let cUser = Firebase.Auth.auth().currentUser
var userName: String = ""
var loading: Bool = false
var categories: [Category] = [Category]()

var currentCategory: Category = Category1

func getUserCategories(){
    //let cUser = Firebase.Auth.auth().currentUser
    db.collection("users").document(cUser!.uid).collection("categories").getDocuments() { (querySnapshot, err) in
        if let err = err {
             print("Error getting documents: \(err)")
        } else {
                var tempCategories: [Category] = [Category]()
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let tempCategory: Category = Category(id: document.get("id") as! String, name: document.get("name") as! String)
                    
                    tempCategories.append(tempCategory)
                }
            sortCategories(categories1: tempCategories)
        }
    }
}
func sortCategories(categories1: [Category]){
    var tempCategories: [Category] = categories1.sorted {$0.name < $1.name }
    let favorites: Category = Category(id: "01", name: "Favorites")
    let athoughts: Category = Category(id: "02", name: "All Thoughts")
    tempCategories.insert(favorites, at: 0)
    tempCategories.insert(athoughts, at: 0)
    categories = tempCategories
    print("ORGANIZED")
    print(categories)
}
class categoryData: ObservableObject{
    var objectWillChange = PassthroughSubject<Void, Never>()
    @Published var categories: [Category] = [Category](){
        willSet{
            objectWillChange.send()
        }
    }
    func getUserCategories(){
        //let cUser = Firebase.Auth.auth().currentUser
        db.collection("users").document(cUser!.uid).collection("categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                 print("Error getting documents: \(err)")
            } else {
                    var tempCategories: [Category] = [Category]()
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let tempCategory: Category = Category(id: document.get("id") as! String, name: document.get("name") as! String)
                        
                        tempCategories.append(tempCategory)
                    }
                    //print(tempThoughts)
                self.sortCategories(categories1: tempCategories)
                    //categories = tempCategories
                
            }
        }
    }
    func sortCategories(categories1: [Category]){
        var tempCategories: [Category] = categories1.sorted {$0.name < $1.name }
        let favorites: Category = Category(id: "01", name: "Favorites")
        let athoughts: Category = Category(id: "02", name: "All Thoughts")
        tempCategories.insert(favorites, at: 0)
        tempCategories.insert(athoughts, at: 0)
        categories = tempCategories
        print("ORGANIZED")
        print(categories)
    }
    func deleteCategory(categoryID: String){
        db.collection("users").document(cUser!.uid).collection("categories").document(categoryID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    func createCategory(categoryName: String, alreadyExists: Bool){
        
        if categoryName != "" && !alreadyExists{
            let newCategory =  db.collection("users").document(cUser!.uid).collection("categories").document()
            newCategory.setData(["id":newCategory.documentID, "name": categoryName.prefix(30)])
            
            let newCat = Category(id: newCategory.documentID, name: String(categoryName.prefix(30)))
            currentCategory = newCat
        }
    }
}

func handlePostButton(content: String, isFavorite: Bool){
    loading = true
    print("post button pressed!")
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let displayDate = formatter.string(from: date)
    formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    let referenceDate = formatter.string(from: date)
    let cUser = Firebase.Auth.auth().currentUser
    let db = Firestore.firestore()
    /*
    let newDocument = db.collection("users").document(cUser!.uid).collection("All Thoughts").document()
    newDocument.setData(["id":newDocument.documentID, "content": content, "timestamp": displayDate, "reftimestamp": referenceDate, "isFavorite": isFavorite])*/
    print(selectedCategory.name)
    let newDocument = db.collection("users").document(cUser!.uid).collection("All Thoughts").document()
    newDocument.setData(["id":newDocument.documentID, "content": content, "timestamp": displayDate, "reftimestamp": referenceDate, "isFavorite": isFavorite, "category": selectedCategory.name])
    let newThought = Thought(id: newDocument.documentID, content: content, dateCreated: displayDate, refDate: referenceDate, isFavorite: isFavorite, category: selectedCategory.name)
    allthoughts.insert(newThought, at: 0)
    print(allthoughts)
    selectedCategory = Category1
    loading = false
}
func updateContentField(content: String, docID: String){
    db.collection("users").document(cUser!.uid).collection("All Thoughts").whereField("id", isEqualTo: docID).getDocuments() { (querySnapshot, err) in
    if let err = err {
        print("Error getting documents: \(err)")
    } else {
        for document in querySnapshot!.documents {
            document.reference.updateData(["content" : content])
        }
    }
    }
}
func updateCategoryField(category: String, docID: String){
    db.collection("users").document(cUser!.uid).collection("All Thoughts").whereField("id", isEqualTo: docID).getDocuments() { (querySnapshot, err) in
    if let err = err {
        print("Error getting documents: \(err)")
    } else {
        for document in querySnapshot!.documents {
            //let temp: String = document.get("category") as! String
            document.reference.updateData(["category" : category])
        }
    }
    }
}
func toggleFavorite(thought: Thought){
   let cUser = Firebase.Auth.auth().currentUser
    db.collection("users").document(cUser!.uid).collection("All Thoughts").whereField("content", isEqualTo: thought.content).getDocuments() { (querySnapshot, err) in
    if let err = err {
        print("Error getting documents: \(err)")
    } else {
        for document in querySnapshot!.documents {
            let value: Bool = document.get("isFavorite") as! Bool
            document.reference.updateData(["isFavorite" : !value])
        }
    }
    }
}


func getUserDocuments() {
   loading = true
    let cUser = Firebase.Auth.auth().currentUser
    if cUser == nil{
        return
    }
    let docRef = db.collection("users").document(cUser!.uid)

    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            userName = document.get("name") as! String
            print("Got document data!")
        } else {
            print("Document does not exist")
        }
    }
    db.collection("users").document(cUser!.uid).collection("All Thoughts").getDocuments() { (querySnapshot, err) in
        if let err = err {
             print("Error getting documents: \(err)")
        } else {
                var tempThoughts: [Thought] = [Thought]()
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let tempThought: Thought = Thought(id: document.get("id") as! String, content: document.get("content") as! String, dateCreated: document.get("timestamp") as! String, refDate: document.get("reftimestamp") as! String, isFavorite: (document.get("isFavorite") as! Bool), category: document.get("category") as! String)

                    tempThoughts.append(tempThought)
                }
                //print(tempThoughts)
                sortThoughts(thoughts1: tempThoughts, isCategory: false)
                //thoughts = tempThoughts
            
        }
    }
}
func getFavoriteUserDocuments(){
  let cUser = Firebase.Auth.auth().currentUser
    db.collection("users").document(cUser!.uid).collection("All Thoughts").whereField("isFavorite", isEqualTo: true)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    var tempFavoriteThoughts: [Thought] = [Thought]()
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let tempThought: Thought = Thought(id: document.get("id") as! String, content: document.get("content") as! String, dateCreated: document.get("timestamp") as! String, refDate: document.get("reftimestamp") as! String, isFavorite: (document.get("isFavorite") as! Bool), category: document.get("category") as! String)

                        tempFavoriteThoughts.append(tempThought)
                    }
                    sortThoughts(thoughts1: tempFavoriteThoughts, isCategory: true)
                    //categoryThoughts = tempFavoriteThoughts
                    print("GOT FAVORITES")
                }
            }
    }
}

func sortThoughts(thoughts1: [Thought], isCategory: Bool){
    var tempThoughts: [Thought] = [Thought]()
    var convertedArray: [Date] = []
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    for thought in thoughts1 {
        let date = dateFormatter.date(from: thought.refDate)
        if let date = date {
            convertedArray.append(date)
        }
    }
    let ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
    for dat in ready {
        let date = dateFormatter.string(from: dat)
        for thought in thoughts1 {
            if date == thought.refDate{
                tempThoughts.append(thought)
            }
        }
    }
    print(tempThoughts)
    if(isCategory){
        categoryThoughts = tempThoughts
    }else{
        allthoughts = tempThoughts
    }
    loading = false
}

func deleteThought(thought: Thought){
    db.collection("users").document(cUser!.uid).collection("All Thoughts").document(thought.id).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
    var index = 0
    for x in allthoughts{
        if x.id == thought.id{
            allthoughts.remove(at: index)
        }
        index += 1
    }
}

extension String {
    var wordList: [String] {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
    }
}
