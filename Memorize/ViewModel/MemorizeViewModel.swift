//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ulrich Braß on 19.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

//
// The VIEWMODEL file: is a portal between views and model.
// - binds VIEW to MODEL
// - processes intent by modifying the model
// - notice and publish changes
// A class is chosen, because it is easily sharable
//
class MemorizeViewModel {
    private var gameModel = MemorizeViewModel.createMemoryGame()
    
    static func createMemoryGame () -> Game<String> {
        var emojis = Theme.getRandomTheme()
        // start with random number of pairs: required task 4
        return Game<String>(numberOfPairsOfCards: max(2, (6.arc4random))) {_ in
            // deliver content for pair with number 'pairIndex' from given theme
            String(emojis.removeFirst())
        }
    }
    
    // MARK: - Access to model for views (portal)
    var cards : [Game<String>.Card] {
        gameModel.cards                 //return can be ommitted
    }
    
    // MARK: - User Intents - provide functions, that allow views to access the model
    func chooseCard(card chosenCard : Game<String>.Card) {
        gameModel.choose(card: chosenCard)
    }
    
}
