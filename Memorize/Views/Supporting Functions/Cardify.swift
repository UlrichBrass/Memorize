//
//  Cardify.swift
//  Memorize
//
//  Created by Ulrich Braß on 02.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// ViewModifier is a mechanism for making incremental modifications to Views.
// Here we want to give the look and feel of a card to some content to which we apply the modifier
struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    private let radius : CGFloat = 10.0
    private let lineWidth : CGFloat = 3.0
    private let faceUpColor = Color.white
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: radius).fill(faceUpColor)
                RoundedRectangle(cornerRadius: radius).stroke(lineWidth: lineWidth)
                content
            } else {
               RoundedRectangle(cornerRadius: radius).fill()
            }
        } // ZStack
    } // body
} // Cardify

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
        
    }
}
