//
//  GeometryGetter.swift
//  thoughts
//
//  Created by Sam McGarry on 1/30/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}

