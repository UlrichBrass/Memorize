//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Ulrich Braß on 27.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

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


extension Color {
    init(_ rgba: UIColor.RGBA) {
        self.init(UIColor(rgba))
    }
}

extension UIColor {
    public struct RGBA: Hashable, Codable {
         var red: CGFloat
         var green: CGFloat
         var blue: CGFloat
         var alpha: CGFloat
    }
    convenience init(_ rgb: RGBA) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    public var rgba: RGBA {
         var red: CGFloat = 0
         var green: CGFloat = 0
         var blue: CGFloat = 0
         var alpha: CGFloat = 0
        // UIColor has a built-in method called getRed(), which unpacks the RGBA values into variable floats
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }
}
 
