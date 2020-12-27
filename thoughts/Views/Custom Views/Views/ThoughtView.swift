//
//  ThoughtView.swift
//  thoughts
//
//  Created by Sam McGarry on 12/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import SwiftUI

struct ThoughtView: View {
    var thought: Thought
    var body: some View {
        NavigationLink(destination: ThoughtPopUpView(thought: thought, input: thought.content, isEditing: false)) {
        VStack(alignment: .leading) {
            HStack {
                Text(thought.refDate)
                    .font(.subheadline)
                    .padding(5)
                    .background(Colors.darkgray) .foregroundColor(Colors.textcolor)
                    .cornerRadius(5)
                    .multilineTextAlignment(.leading)
                
                if thought.category != ""{
                    Text(thought.category.prefix(20))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(5)
                        .background(Colors.darkgray) .foregroundColor(Colors.textcolor)
                    .cornerRadius(5)
                    .multilineTextAlignment(.leading)
                    
                    .frame(maxHeight: 28)
                    .lineLimit(1)
                }
                if thought.isFavorite{
                    Image(systemName: "star.fill")
                    .frame(width: 40, height: 28)
                        .background(Colors.darkgray)
                    .foregroundColor(buttonColor)
                    .cornerRadius(5)
                }
                if !thought.isFavorite{
                    Image(systemName: "star.fill")
                    .frame(width: 40, height: 28)
                        .background(Colors.darkgray)
                    .foregroundColor(buttonColor)
                    .cornerRadius(5)
                }
                
            }.padding(.bottom, 0)
            HStack {
                Text(thought.content)
                    .font(.headline)
                    .padding(5)
                    .background(LinearGradient(gradient: Gradient(colors: [Colors.chillblue, Colors.niceblue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(Color.white)
                    .cornerRadius(5) .multilineTextAlignment(.center)
                    .padding(.trailing)
                    .lineLimit(10)
                    
            }
        }.shadow(radius: 5)
    }
    }
    var buttonColor: Color {
        if thought.isFavorite == true{
            return Color.yellow
        }else{
            return Colors.textcolor
        }
    }
}


struct ThoughtView_Previews: PreviewProvider {
    static var previews: some View {
        ThoughtView(thought: Thought1)
    }
}

