//
//  Theme.swift
//  Memorize
//
//  Created by Ulrich Braß on 20.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI



// The Themes of the game, that can be chosen of
struct Theme {
    // The attributes of a persistent Theme, using the Codable protocol.
    // Prerequisite: make all types simple types (e.g. Int, String, Double, CGFloat, URL, Array, Dictionary, Set, etc.)
    struct ThemeItem : Hashable, Codable, Identifiable {
        // The ID
        var id : Int  = newID()
        
        // Properties, that willl be initialised from json file
        var themeName : String
        var themeEmojis : String
        
        // Color Management:
        //  Represent colors inside Theme as a struct with 4 floating point numbers:
        //  the color’s red, green, blue and alpha (transparency) levels (aka RGBA)
        var themeColor : UIColor.RGBA
        //Conversion between UIColor and RGBA internal coding
        var themeUIColor: UIColor {
            get {
                UIColor(self.themeColor)
            }
            set{
                self.themeColor = newValue.rgba
            }
        }
        //
        
        // Remaining acquired properties ...
        
        // ... the ones shown on the home screen
        var lastScore : Int = 0
        var bestScore : Int  = 0
        
        // ... the ones that are used to make the game easier or harder
        var noOfPairsOfCards : Int = 1
        var bonusTimeLimit : Int = maxBonusTimeLimit / 2
        
        
        // Init functions
        static var nextID = 5000 // imported IDs will start from 1000
        
        static func newID () -> Int {
            Theme.ThemeItem.nextID = Theme.ThemeItem.nextID + 1
            return Theme.ThemeItem.nextID
        }
        
        // Constants and key names
        
        static let maxBonusTimeLimit =  14
        static let maxNoOfPairsOfCards = 16
        static let noEmojis = "?"
        static let defaultThemeItem = ThemeItem(themeName : "Default", themeEmojis : noEmojis, themeColor : UIColor.clear.rgba)
    }

    // The Theme table
    var themeList : [ThemeItem]
    var themeCount : Int {
        themeList.count
    }
    // a new theme is added to the theme list
     mutating func addTheme() {
          // a new empty entry
         self.themeList.append(Theme.ThemeItem(themeName :  "Neues Thema", themeEmojis : Theme.ThemeItem.noEmojis, themeColor : UIColor.black.rgba))
     }
     // delete entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
     mutating func deleteThemes(offsets: IndexSet) {
         self.themeList.remove(atOffsets: offsets)
     }
      // move entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
     mutating func moveThemes(from: IndexSet, to: Int) {
         self.themeList.move(fromOffsets: from, toOffset: to)
     }
     
     // store score values in User Defaults
    mutating func storeScore(theme : Theme.ThemeItem, scoreCount : Int){
         if let themeNo = self.themeList.firstIndex(matching: theme) {
             self.themeList[themeNo].lastScore = scoreCount
             self.themeList[themeNo].bestScore = max(scoreCount, self.themeList[themeNo].bestScore)
         }
     }
     // store themeItem object in User Defaults
     mutating func storeThemeItem(theme : Theme.ThemeItem){
         if let themeNo = self.themeList.firstIndex(matching: theme) {
             self.themeList[themeNo].themeName = theme.themeName
             self.themeList[themeNo].themeEmojis = theme.themeEmojis
             self.themeList[themeNo].themeColor = theme.themeColor
             self.themeList[themeNo].noOfPairsOfCards = theme.noOfPairsOfCards
             self.themeList[themeNo].bonusTimeLimit = theme.bonusTimeLimit
         }
     }
   
    
    let defaultGameDataFname = "MemorizeThemes.json"
    
    //Decodes json file into themeList array
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        // the bundle object that contains the current executable
        // Returns the file URL for the resource file identified by the specified name and extension and residing in the bundle directory.
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: fileUrl)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    
    //Encodes themeList array into json format, and returns it
    func json<T: Encodable>( themeList : T) ->Data  {
        var json : Data
        // encode the theme List into json
        do {
            let encoder = JSONEncoder()
            json = try encoder.encode(themeList)
        } catch {
            fatalError("Couldn't encode themeList as \(T.self):\n\(error)")
        }
        return json
    }
    
    // init with loading from data file, if failable initializer didi not work
    init () {
        self.themeList = Theme.load(defaultGameDataFname)
    }
    
    //create by reading from JSON input data, failable initializer
    init?(json: Data?) {
        if json != nil, let newThemeList = try? JSONDecoder().decode([ThemeItem].self, from: json!) {
            // replace self from JSON input
            self.themeList = newThemeList
        } else {
            return nil
        }
    }
}

