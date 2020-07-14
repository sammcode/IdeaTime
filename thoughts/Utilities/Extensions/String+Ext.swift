//
//  String+Ext.swift
//  thoughts
//
//  Created by Sam McGarry on 7/14/20.
//  Copyright © 2020 Sam McGarry. All rights reserved.
//

import Foundation

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
