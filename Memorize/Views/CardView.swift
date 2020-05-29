//
//  CardView.swift
//  Memorize
//
//  Created by Ulrich Braß on 25.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// A view of a single card
struct CardView : View {
    var card : ModelType.Card

    let radius : CGFloat = 10.0
    let lineWidth : CGFloat = 3.0
    let faceUpColor = Color.white
    let scale_factor : CGFloat = 0.75
    
    // the space for one card
    var body: some View {
        GeometryReader{ geometry in
            self.body(for : geometry.size)
        } //Geometry Reader
    } // Body
    
    // remove matched cards and show either face up or not
    func body (for size : CGSize) -> some View {
        Group{
            if !card.isMatched {
                self.showCard(with : card.content, if : self.card.isFaceUp )
            } // else show nothing: card has been removed from game already
        }
            // Have the font adjusted to the actual size
            .font(Font.system(size: self.fontSize(for : size)))
            
    }
    // adjust font size to actual space
    func fontSize(for size : CGSize) -> CGFloat {
        self.scale_factor * min(size.width, size.height)
    }
    // show the card with animation of flipping
    func showCard ( with content : String, if isFaceUp : Bool) -> some View {
       // ZStack(content: () -> _): A view that overlays its children, aligning them in both axes.
        ZStack {
            if isFaceUp {
                   RoundedRectangle(cornerRadius: radius).fill(faceUpColor)
                   RoundedRectangle(cornerRadius: radius).stroke(lineWidth: lineWidth)
                   Text(content)
            } else {
                   RoundedRectangle(cornerRadius: radius).fill()
            }
        } // ZStack
        // Basic animation of flipping the card
        // need to use the 'isFaceUp' variable to ensure that the view is rerendered
        .rotation3DEffect( isFaceUp ? Angle(degrees: 0) : Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
        // “call” the animation  by using .animation(.<animation-type>) modifier on the view
        .animation(.linear(duration : 0.5))
        
    }
    
} // CardView


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card : ModelType.Card(id : 0, content : "?"))
    }
}
