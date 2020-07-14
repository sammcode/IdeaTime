//
//  Thought.swift
//  thoughts
//
//  Created by Sam McGarry on 12/12/19.
//  Copyright © 2019 Sam McGarry. All rights reserved.
//
import Foundation
import SwiftUI

struct Thought: Hashable, Codable, Identifiable{
    var id: String
    var content: String
    var dateCreated: String
    var refDate: String
    var isFavorite: Bool
    var category: String
}
