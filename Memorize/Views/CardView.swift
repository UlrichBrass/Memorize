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

    private let scale_factor : CGFloat = 0.7
    
    // adjust font size to actual space
    private func fontSize(for size : CGSize) -> CGFloat {
        self.scale_factor * min(size.width, size.height)
    }
    
    // the space for one card
    var body: some View {
        GeometryReader{ geometry in
            self.body(for : geometry.size)
        } //Geometry Reader
    } // Body
   
    @State private var animatedBonusRemaining : Double = 0
    
    private func startBonusTimeAnimation(){
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration : card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    // remove matched cards and show either face up or face down
    @ViewBuilder
    private func body (for size : CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            
            // ZStack(content: () -> _): A view that overlays its children, aligning them in both axes.
            ZStack {
                Group {
                    // animated pie
                    if card.isConsumingBonusTime {
                        PieLayout(startAngle: Angle(degrees : 0 - 90), endAngle: Angle(degrees : -animatedBonusRemaining * 360 - 90.0), clockwise : true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        // static pie
                        PieLayout(startAngle: Angle(degrees : 0 - 90), endAngle: Angle(degrees : -card.bonusRemaining * 360 - 90.0), clockwise : true)
                    }
                } // Group
                    .padding(3)
                    .opacity(0.4)
                Text(card.content)
                    // Have the font adjusted to the actual size
                    .font(Font.system(size: self.fontSize(for : size)))
                    // Basic implicit animation of rotating the symbol in case of a match
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration : 1.0).repeatForever(autoreverses : false) : .default)
            } // ZStack
            // make this ZStack have a card look and feel with animation
                .cardify(isFaceUp : card.isFaceUp)
                // By default, SwiftUI uses a fade animation to insert or remove views, but you can change that if you want by attaching a
                // transition() modifier to a view.
                // the .scale transition causes a view to be scaled to nothing when going out, .offset would make cards fly around
                .transition(AnyTransition.scale)
            
        }
            // else show nothing: card has been removed from game already, transition applies
    }
  
} // CardView


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card : ModelType.Card(isFaceUp : true, content : "👻" ))
            .padding(5)
            .foregroundColor(Color.orange)
            .aspectRatio(2/3, contentMode: .fit)
    }
}

