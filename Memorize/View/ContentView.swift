//
//  ContentView.swift
//  Memorize
//
//  Created by Ulrich Braß on 19.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI
//
// The VIEW file: Reflects the model stateless, declared, reactive
// - automatically observes publications
// - pulls data and rebuilds

// You create custom views by declaring types that conform to the View protocol.
// The View protocol provides a large set of modifiers, defined as protocol methods with default implementations,
// that you use to position and configure views in the layout of your app
struct ContentView: View {
    var viewModel : MemorizeViewModel
    //Implement the required body computed property to provide the content for your custom view.
    // Assemble the view’s body by combining one or more of the primitive views provided by SwiftUI, plus other custom views
    // that you define, into a hierarchy of views.
    let color = Color.orange
    var body: some View {
        // Have the font adjust in the 5 pair case (only) to use a smaller font than: required task 5
        let font = viewModel.cards.count < 10 ?  Font.largeTitle : Font.title
        // HStack(content: () -> _ ): A view that arranges its children in a horizontal line.
        return HStack{
            // ForEach(data: Range<Int>, content:(Int) -> _) :The collection of underlying identified data
            // that SwiftUI uses to create views dynamically.
            // Work through 'portal':
            ForEach (viewModel.cards) { card in     // The 'in' keyword indicates that the definition of the closure’s parameters and return type
                                                    // has finished, and the body of the closure is about to begin
                CardView(card : card).onTapGesture { // will closure after recognizing a tap gesture.
                    self.viewModel.chooseCard(card: card)
                }
            } //ForEach
        }//HStack
        // HStack modifiers
            //The effects of a modifier typically propagate to any child views that don’t explicitly override the modifier.
            // Here the HStack instance on its own acts only to horizontally stack other views, and has no text to display.
            // Therefore, the font(_:) modifier that we apply to the stack has no effect on the stack itself. Yet the font modifier
            // does apply to any of the stack’s child views, some of which might display text.
            // On the other hand, you can locally override the stack’s modifier by adding another one to a specific child view
            .padding()
            .foregroundColor(color)
            .font(font)
        // HStack modifiers
    } // body
} // View



struct CardView : View {
    var card : Game<String>.Card
    let radius = CGFloat(10.0)
    let lineWidth = CGFloat(3.0)
    let color = Color.white
    var body: some View {
        // ZStack(content: () -> _): A view that overlays its children, aligning them in both axes.
        ZStack {
            if card.isFaceUp {
                // Modifiers typically work by wrapping the view instance on which you call them in another view with the s
                // pecified characteristics.
                RoundedRectangle(cornerRadius: radius).fill(color)
                RoundedRectangle(cornerRadius: radius).stroke(lineWidth: lineWidth)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: radius).fill()
            }
        } // ZStack
        // Force each card to have a width to height ratio of 2:3, required task 3
         .aspectRatio(CGSize(width : 2, height : 3), contentMode: .fit)
    } // Body
} // View



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel : MemorizeViewModel())
    }
}
