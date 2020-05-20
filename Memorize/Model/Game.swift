//
//  Game.swift
//  Memorize
//
//  Created by Ulrich Braß on 19.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation
//
// The MODEL file: UI independant data + logic
//
struct Game <CardContent> {
    var cards : [Card]
    
    class Card : Identifiable { // a class is needed to make cards mutable
        // make Card a class  holding  the value of an entity with stable identity.
        var id: Int
        
        var isFaceUp : Bool
        var isMatched : Bool
        var content : CardContent
        
        func flip () {
            self.isFaceUp = !self.isFaceUp
        }
        
        init(id: Int, isFaceUp : Bool = true, isMatched : Bool = false, content : CardContent){
            self.id = id
            self.isFaceUp = isFaceUp
            self.isMatched = isMatched
            self.content = content
        }
    }
    
    func choose(card chosenCard : Card){
        chosenCard.flip()
        //print("card chosen: \(chosenCard.id)")
    }
    
    init(numberOfPairsOfCards : Int, cardContentFactory : (Int)->CardContent){
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id : pairIndex * 2, content: content ))
            cards.append(Card(id : pairIndex * 2 + 1, content: content))
        }
        // make cards appear in random order. Required task 1
        cards.shuffle()
    }
}
