//
//  Theme.swift
//  Memorize
//
//  Created by Ulrich Braß on 20.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation



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
    
    let fname = "gameData.json"
    
    //Decodes json file into themeList array
    private func load<T: Decodable>(_ filename: String) -> T {
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
    
    //Encodes themeList array into json file
    private func store<T: Encodable>(_ filename: String,  themeList : T)  {
        var data : Data
        // encode the theme List into json
        do {
            let encoder = JSONEncoder()
            data = try encoder.encode(themeList)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
        
        // Returns the file URL for the resource file identified by the specified name and extension and residing in the bundle directory.
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        // stores the data to disk, by overwriting json file
        do {
            try data.write(to: fileUrl, options: .noFileProtection )
        } catch {
            fatalError("Couldn't store \(filename) in main bundle:\n\(error)")
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
    
    // store data file
    func storeThemes(){
        store(fname, themeList: themeList)
    }
    // load data file
    init () {
        self.themeList = load(fname)
    }
}

