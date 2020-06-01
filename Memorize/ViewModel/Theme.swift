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
    // The attributes of a Theme
    struct ThemeItem : Hashable, Codable, Identifiable {
        var id : Int
        var name : String
        var emojis : String
        var colorName: String
        var gameNo : Int
        var bestScore : Int
    }

    // The Theme table
    var themeList : [ThemeItem]!
    var themeCount : Int {
        themeList.count
    }
    //Decodes json file into landmark array
    private func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        // the bundle object that contains the current executable
        // Returns the file URL for the resource file identified by the specified name and extension and residing in the bundle directory.
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
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
    
    // return specific theme
    func getTheme(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind].emojis : ""
    }
       // return specific theme name
    func getThemeName(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind].name : ""
    }
       // return specific theme color
    func getThemeColorName(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind].colorName : ""
    }
    
    
    init () {
        self.themeList = load("gameData.json")
    }
}

