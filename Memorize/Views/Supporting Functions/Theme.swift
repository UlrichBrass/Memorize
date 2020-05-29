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
    struct ThemeItem {
        var name : String
        var emojis : String
        var color: Color
        
        init(name: String, emojis: String, color: Color? = nil) {
            self.name = name
            self.emojis = emojis
            self.color = color ?? Color("Memorize" + name + "Color")
        }
    }

    // The Theme table
    static var themeList : [ThemeItem] =
        [ThemeItem(name: "Halloween",emojis: "🎃👻🦇👿😱👽🐙🍩🥳🙀🤡🤖💩👀🧠👅"),
         ThemeItem(name: "Sport",emojis: "🎱⚾️⚽️🏀🏈🏓🥊⛷🏄🏻‍♂️🏊‍♂️🚴‍♀️🚣‍♀️🏋️‍♂️🪂🏹🏒", color: Color.red),
         ThemeItem(name: "Essen",emojis: "🍎🍐🍉🍇🧅🥔🥨🍔🥗🥘🍱🥖🍗🥞🧇🥚", color: Color.blue),
         ThemeItem(name: "Fahrzeuge",emojis: "🚗🚌🚒🚜🛴🚲🛵🚠🚂✈️🚀🚁⛵️🚤🛶🚑", color: Color.yellow),
         ThemeItem(name: "Tiere",emojis: "🐶🐹🐸🐔🐥🐝🦄🦋🦈🦧🐐🦜🐿🦔🦨🐘"),
         ThemeItem(name: "Gebäude",emojis: "🏰🏟🏠🏭🏦💒🕌⛩⛺️⛲️🗽🗿🏯🎠🏪🏥", color: Color.gray),
         ThemeItem(name: "Flaggen",emojis: "🏴‍☠️🏳️‍🌈🇺🇳🇧🇪🇧🇷🇪🇺🇩🇪🇫🇷🇮🇱🇮🇹🇯🇵🇸🇪🇺🇸🇬🇧🇹🇷🇳🇴", color: Color.black)
         // add a new Theme as : ,ThemeItem(name: "",emojis: "", color: )
         // if no color is specified, a color with theme name is chosen from custom color catalogue
       ]
    
    
    // return specific theme
    static func getTheme(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind].emojis : ""
    }
    // return specific theme name
    static func getThemeName(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind].name : ""
    }
    // return specific theme color
    static func getThemeColor(index ind : Int) -> Color {
        ind < themeList.count ? themeList[ind].color : Color.clear
    }
}

