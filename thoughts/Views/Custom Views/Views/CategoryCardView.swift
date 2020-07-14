//
//  CategoryCardView.swift
//  thoughts
//
//  Created by Sam McGarry on 1/12/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI

struct CategoryCardView: View {
    var category: Category
    var body: some View {
            ZStack {
                HStack {
                    Text(category.name)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .frame(width: 280)
                        .background(Color("darkgray"))
                        .foregroundColor(Color("textcolor"))
                        .cornerRadius(10) .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .shadow(radius: 5)
                    ZStack {
                        Image(systemName: "folder.circle.fill").resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(cardColor)
                    }
                }
            }
    }
    
    var cardColor: Color {
        if category.name == "All Thoughts" || category.name == "Favorites"{
            return Color("chillorange")
        }else{
            return Color("niceblue")
        }
    }
}

struct CategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCardView(category: Category1)
    }
}
