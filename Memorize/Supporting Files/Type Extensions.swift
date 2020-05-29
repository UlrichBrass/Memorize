//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Ulrich Braß on 27.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation

// find index of an identifiable item in an array of items
extension Array where Element : Identifiable{
    func firstIndex(matching element: Element) -> Int? {
        return self.firstIndex{$0.id == element.id}
    }
}

// Extend array to find out if it contains only a single element
extension Array {
    var oneAndOnly : Element? {
        get {
            return count == 1 ? first : nil
        }
    }
}

// Int extension used for random number generatiom from 0..<self
extension Int {
    var arc4random : Int {
        get {
            return (self > 0 ?
                        Int(arc4random_uniform(UInt32(self))) :
                        (self < 0 ?
                            -Int(arc4random_uniform(UInt32(abs(self)))) :
                            0))
        }
    }
}
