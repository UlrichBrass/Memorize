//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ulrich Braß on 19.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation

//
// The VIEWMODEL file: is a portal between views and model.
// - binds VIEW to MODEL
// - processes intent by modifying the model
// - notice and publish changes
// A class is chosen as representation, because it is easily sharable
//
typealias ModelType = MemorizeModel<String>

final class MemorizeViewModel : ObservableObject{
    // published a properties
    @Published  private var gameModel : ModelType?
    @Published  private(set) var gameNo = Array(repeating: 0, count: Theme.themeList.count)
    @Published  private(set) var bestScore = Array(repeating: 0, count: Theme.themeList.count)
    
    func createMemoryGame (themeNo : Int) -> ModelType {
        var emojis = Theme.getTheme(index: themeNo)
        // start with random number of pairs: required task 4
        return ModelType(numberOfPairsOfCards: emojis.count, gameNo : gameNo[themeNo] ) {_ in
            // deliver content for pair with number 'pairIndex' from given theme
            String(emojis.removeFirst())
        }
    }
    
    // MARK: - Access to model for views (portal)
    // Prepare data from MODEL to be presented to a user. A VIEW MODEL structures data in a way that is convenient for a VIEW to consume.
    var cards : [ModelType.Card] {
        gameModel!.cards
    }
    
    var gameScore : Int {
        gameModel!.scoreCount
    }
    
    var flipCount : Int {
        gameModel!.flipCount
    }
    
    // MARK: - User Intents - provide functions, that allow views to access the model
    // Interpret user inputs into actions upon business rules and data. 
    func chooseCard(card chosenCard : ModelType.Card) {
        gameModel!.choose(card: chosenCard)
    }
    
    func storeScore(themeNo : Int){
        self.bestScore[themeNo] = max(gameModel?.scoreCount ?? 0, self.bestScore[themeNo])
    }
    
    func newGame (themeNo : Int) {
        self.gameModel = createMemoryGame(themeNo : themeNo)
        self.gameNo[themeNo] += 1
        /*
            for i in (0..<Theme.themeList.count){
                print (Theme.getThemeName(index : i) + " " + String(gameNo[i]))
            }
        */
    }
    
}
