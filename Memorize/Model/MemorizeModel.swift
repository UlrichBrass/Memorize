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
// The MODEL is the software representation of the business concepts that bring value to the customer. It is the primary reason why the iOS app is actually written.
//
struct MemorizeModel <CardContent> where CardContent : Equatable{
    var cards : [Card]
    
    // Handle card that is open from last time
    private var indexOfOneAndOnlyFaceUpCard : Int? {
        // Find card open from last time (if any)
        get {
            // filter uses a closure that takes an element of the sequence as its argument and returns a Boolean value
            // indicating whether the element should be included in the returned array.
            cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly // make sure it is exactly one
        }
        // Mark card as open
        set (newValue){
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // Scoring
    private(set) var flipCount  = 0, scoreCount = 0
    
    // This function changes the state of the game, based on user choice and therefore has to be mutating
    mutating func choose(card chosenCard : Card){
        if let index = cards.firstIndex(matching : chosenCard){
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                // There is one card face up, and I need to match it with the new card (but ignore if same card chosen)
                if cards[matchIndex].content == cards[index].content {
                        // They match, mark both as matched
                        scoreCount += 2
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                    } else{
                        // a mismatch
                        for i in [index, matchIndex] {
                            if cards[i].alreadySeen {
                                scoreCount -= 1
                            }
                            else {
                                cards[i].alreadySeen = true
                            }
                        }
                    }
                // In any case I need to make the card face up and mark, that more than one card is face up
                    cards[index].isFaceUp = true
                } else {
                // No cards are face up: flip it over
                // Two cards are face up (matching or not). Those need to be flipped face down, because I start a new match now
                // Is done now with computed property
                    indexOfOneAndOnlyFaceUpCard = index
                }
                flipCount += 1
            } // else do nothing index of chosen card not found
    }
    // Ensure that card IDs are unique over multiple games, to avoid obscure UI behavior
    init(numberOfPairsOfCards : Int, cardContentFactory : (Int)->CardContent){
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards += [Card( content: content ), Card( content: content )]
        }
        // make cards appear in random order. Required task 1
        cards.shuffle()
    }
    
    // Encapsulated data structure for cards
    struct Card : Identifiable {
        // make Card a struct holding  the value of an entity with stable identity.
        // We cannot make Card to implement Equatable, because then CardView will not update views as long as id remains the same!!!
        var id : UUID
        
        // Card Properties
        var isFaceUp : Bool
        var isMatched : Bool
        var alreadySeen : Bool
        var content : CardContent
        
        init( isFaceUp : Bool = false, isMatched : Bool = false, alreadySeen : Bool = false, content : CardContent){
            self.id = UUID()
            self.isFaceUp = isFaceUp
            self.isMatched = isMatched
            self.alreadySeen = alreadySeen
            self.content = content
        }
    } // Card
    
} // Game
