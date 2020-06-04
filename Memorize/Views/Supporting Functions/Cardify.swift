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
// We also want to animate card flipping, tehrefore we make it an AnimatableModifier
struct Cardify: AnimatableModifier {
    var rotation : Double
    var isFaceUp: Bool {
        rotation < 90
    }
    
   
    // The communication with the animation system happens (both ways) with a single var.
    // This var is the only thing in the Animatable protocol.
    // Shapes and ViewModifiers that want to be animatable must implement this protocol.
    // Because it’s communicating both ways, this animatableData is a read-write var.
    // We do not want to use the name “animatableData” in our Shape/VM code
    // (we want to use variable names that are more descriptive of what that data is to us).
    // So the get/set  just gets/sets rotation
    // (essentially exposing them to the animation system with a different name).
    var animatableData: Double{ // Type has to implement the protocol VectorArithmetic, and is almost always a floating point number
        // The getting of this var is the animation system getting the start/end points of an animation.
        get{ return rotation}
        // The setting of this var is the animation system telling the Shape/VM which piece to draw.
        set{ rotation = newValue}
    }
    
    private let radius : CGFloat = 10.0
    private let lineWidth : CGFloat = 3.0
    private let faceUpColor = Color.white
    
    init(isFaceUp : Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        // front side and back side are always 'visible' but partly hidden based on value of isFaceUp
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: radius).fill(faceUpColor)
                RoundedRectangle(cornerRadius: radius).stroke(lineWidth: lineWidth)
                content
            }
                // hide back side if isFaceUp
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: radius).fill()
                // hide front side if isFaceUp
                .opacity(isFaceUp ? 0 : 1)
        } // ZStack
        
        // Basic implicit animation of flipping the card
        // need to use the 'isFaceUp' variable to ensure that the view is rerendered
            .rotation3DEffect( Angle.degrees(rotation), axis: (0, 1, 0))
    } // body
} // Cardify

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
        
    }
}
