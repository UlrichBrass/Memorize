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
    // published properties
    @Published  private var gameModel : ModelType?  // the game
    @Published  private(set) var themes = Theme()   // its themes
    @Published  var profile = Profile.default       // the profile
    
    
    private func createMemoryGame (themeNo : Int) -> ModelType {
        var emojis = themes.getTheme(index: themeNo)
        // start with random number of pairs: required task 4
        return ModelType(numberOfPairsOfCards: profile.noOfPairsOfCards, bonusTimeLimit : profile.bonusTimeLimit ) {_ in
            // deliver content for pair with number 'pairIndex' from given theme
            String(emojis.removeFirst())
        }
    }
    
    // MARK: - Access to model for views (portal)
    // Prepare data from MODEL to be presented to a user. A VIEW MODEL structures data in a way that is convenient for a VIEW to consume.
    var cards : [ModelType.Card] {
        gameModel?.cards ?? [ModelType.Card]()
    }
    
    var gameScore : Int {
        gameModel?.scoreCount ?? 0
    }
    
    var flipCount : Int {
        gameModel?.flipCount ?? 0
    }
    
    func lastScore(themeNo : Int) -> Int {
        themes.themeList[themeNo].lastScore
    }
    
    func bestScore(themeNo : Int) -> Int {
        themes.themeList[themeNo].bestScore
    }
    // MARK: - User Intents - provide functions, that allow views to access the model
    // Interpret user inputs into actions upon business rules and data. 
    func chooseCard(card chosenCard : ModelType.Card) {
        gameModel!.choose(card: chosenCard)
    }
    
    // store score values in User Defaults
    func storeScore(themeNo : Int){
        themes.themeList[themeNo].lastScore = gameModel?.scoreCount ?? 0
        themes.themeList[themeNo].bestScore = max(gameModel?.scoreCount ?? 0, bestScore(themeNo : themeNo))
    }
    // start new game
    func newGame (themeNo : Int) {
        gameModel = createMemoryGame(themeNo : themeNo)
    }
} // class
