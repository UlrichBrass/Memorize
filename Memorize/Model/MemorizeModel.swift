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
    // cards are visible, but cannot be changed from a view
    private(set) var cards : [Card]
    // Scoring
    private(set) var flipCount  = 0, scoreCount = 0
    
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
                                // we want to give another malus if bonus time was fully consumed, and card turned face up again
                                if cards[index].bonusTimeRemaining == 0 {
                                    scoreCount -= 1
                                }
                            }
                            else {
                                cards[i].alreadySeen = true
                            }
                        }
                    }
                // In any case I need to make the card face up
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
            cards += [Card( id :  2 * pairIndex, content: content ), Card( id : 2 * pairIndex + 1, content: content )]
        }
        // make cards appear in random order. Required task 1
        cards.shuffle()
    }
    
    // Encapsulated data structure for cards
    struct Card : Identifiable {
        // make Card a struct holding  the value of an entity with stable identity.
        // We cannot make Card to implement Equatable, because then CardView will not update views as long as id remains the same!!!
        var id : Int
        
        // Card Properties
        var isFaceUp : Bool {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched : Bool {
            didSet{
                stopUsingBonusTime()
            }
        }
        var alreadySeen : Bool
        var content : CardContent
        
        init( id : Int = 0, isFaceUp : Bool = false, isMatched : Bool = false, alreadySeen : Bool = false, content : CardContent){
            self.id = id
            self.isFaceUp = isFaceUp
            self.isMatched = isMatched
            self.alreadySeen = alreadySeen
            self.content = content
        }
    
    
        // MARK: - Bonus Time
        // give matching bonus points, if the user matches the card, before a certain amount of time
        // passes during which the card is face up
        
        // can be zero, which means "no bunus available for this card
        var bonusTimeLimit : TimeInterval = 6
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate : Date?
        
        // the accumulated time, this card has been face up in the past
        // That means nort including the time it has been face up currently
        var pastFaceUpTime : TimeInterval = 0
        
        // how long this card has ever been face up
        private var faceUpTime : TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining : TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining : Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0 ? bonusTimeRemaining /  bonusTimeLimit : 0)
        }
        
        // wheter the card was matched during the bonus time period
        var hasEarnedBonus : Bool {
            isMatched && (bonusTimeRemaining > 0)
        }
        
        // whether we are currently face up, unmatched,  and have not yet used up the bonus window
        var isConsumingBonusTime : Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card stops face up state, or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    } // Card
    
} // Game
