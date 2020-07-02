//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ulrich Braß on 19.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation
import Combine

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
    @Published  private var gameModel : ModelType?  // the game, from MemorizeModel model file
    @Published  private var themes : Theme  // its themes, from Theme model file
    
    
    private func createMemoryGame (theme : Theme.ThemeItem) -> ModelType {
        var emojis = theme.themeEmojis
        // start with stored number of pairs of cards
        return ModelType(numberOfPairsOfCards: theme.noOfPairsOfCards, bonusTimeLimit : theme.bonusTimeLimit ) {_ in
            // deliver content for pair with number 'pairIndex' from given theme
            String(emojis.removeFirst())
        }
    }
    
    // MARK: - Access to model for views (portal)
    // Prepare data from MODEL to be presented to a user. A VIEW MODEL structures data in a way that is convenient for a VIEW to consume.
    var cards : [ModelType.Card] {
        gameModel?.cards ?? [ModelType.Card]()
    }
    
    var themeList : [Theme.ThemeItem] {
        themes.themeList
    }
    
    var gameScore : Int {
        gameModel?.scoreCount ?? 0
    }
    
    var flipCount : Int {
        gameModel?.flipCount ?? 0
    }
    
    // MARK: - User Intents - provide functions, that allow views to access the model
    // Interpret user inputs into actions upon business rules and data. 
    func chooseCard(card chosenCard : ModelType.Card) {
        gameModel!.choose(card: chosenCard)
    }
    // a new theme is added to the theme list
    func addTheme() {
        // a new empty entry
        self.themes.addTheme()
    }
    // delete entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
    func deleteThemes(offsets: IndexSet) {
        self.themes.deleteThemes(offsets: offsets)
    }
     // move entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
    func moveThemes(from: IndexSet, to: Int) {
        self.themes.moveThemes(from: from, to: to)
    }
    
    // store score values in User Defaults
    func storeScore(theme : Theme.ThemeItem){
        self.themes.storeScore(theme : theme, scoreCount: gameModel?.scoreCount ?? 0)
    }
    // store themeItem object in User Defaults
    func storeThemeItem(theme : Theme.ThemeItem){
        self.themes.storeThemeItem(theme : theme)
    }
    // start new game
    func newGame (theme: Theme.ThemeItem) {
        gameModel = createMemoryGame(theme : theme)
    }
    
    // cancels subscription if View Model disappears
    private var autosaveCancellable : AnyCancellable?
    // The key for persistent storage of status data
    let MemorizeLastSessionData = "Memorize.State"
    
    // this initializer will bring back everything from last session
    // if has been 
    init() {
        // get themes from data store (last session), if any, else read from input file
        themes = Theme(json: UserDefaults.standard.data(forKey: MemorizeLastSessionData)) ?? Theme()
        // on end of application, store the last session and print to screen
        autosaveCancellable = $themes.sink{ theme in
            let json : Data = theme.json(themeList : theme.themeList)
            UserDefaults.standard.set(json, forKey : self.MemorizeLastSessionData)
            //print(String(data: json, encoding: .utf8)!)
        }
    }
} // class
