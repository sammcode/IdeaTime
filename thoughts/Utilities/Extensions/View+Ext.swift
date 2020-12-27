//
//  View+Ext.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI

extension View {
    func composeToast(isShowing: Binding<Bool>) -> some View {
        ComposePopUp( isShowing: isShowing,
                      presenting: { self }, data: Data())
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}

extension View {
    func toast(isShowing: Binding<Bool>) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self }, viewRouter: ViewRouter()).environmentObject(categoryData())
    }
}

extension View{
    func delCatToast(isShowing: Binding<Bool>, category: Category) -> some View {
        DeleteCategoryPopUp(category: category, isShowing: isShowing,
            presenting: { self }).environmentObject(categoryData())
    }
}

extension View {
    func deleteToast(isShowing: Binding<Bool>, thought: Thought) -> some View {
        DeletePopUp(thought: thought, isShowing: isShowing,
              presenting: { self })
    }
    func addToToast(isShowing: Binding<Bool>, thought: Thought) -> some View {
        AddToPopUp(thought: thought, isShowing: isShowing,
            presenting: { self }).environmentObject(categoryData())
    }
}
