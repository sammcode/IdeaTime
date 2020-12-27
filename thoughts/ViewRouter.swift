//
//  ViewRouter.swift
//  thoughts
//
//  Created by Sam McGarry on 12/17/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var currentPage:String = "launch"{
        didSet{
            withAnimation(){
                objectWillChange.send(self)
            }
        }
    }
}
