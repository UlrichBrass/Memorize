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
    @Published  private(set) var themes = Theme()
    
    
    private func createMemoryGame (themeNo : Int) -> ModelType {
        var emojis = themes.getTheme(index: themeNo)
        // start with random number of pairs: required task 4
        return ModelType(numberOfPairsOfCards: emojis.count ) {_ in
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
    
    func gameNo(themeNo : Int) -> Int {
        themes.themeList[themeNo].gameNo
    }
    
    func bestScore(themeNo : Int) -> Int {
        themes.themeList[themeNo].bestScore
    }
    // MARK: - User Intents - provide functions, that allow views to access the model
    // Interpret user inputs into actions upon business rules and data. 
    func chooseCard(card chosenCard : ModelType.Card) {
        gameModel!.choose(card: chosenCard)
    }
    
    func storeScore(themeNo : Int){
        themes.themeList[themeNo].bestScore = max(gameModel?.scoreCount ?? 0, bestScore(themeNo : themeNo))
        // storing config file disabled for now, because not working on "real" iphone, but only the simulator
        //themes.storeThemes()
    }
    
    func newGame (themeNo : Int) {
        gameModel = createMemoryGame(themeNo : themeNo)
        themes.themeList[themeNo].gameNo +=  1
    }
   
}
