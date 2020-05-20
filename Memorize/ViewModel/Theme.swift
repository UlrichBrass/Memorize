//
//  Theme.swift
//  Memorize
//
//  Created by Ulrich Braß on 20.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation


struct Theme {
    
    static var themeList =
        [["Halloween","🎃👻🦇👿😱👽🐙🍩🥳🙀🤡🤖💩👀🧠👅"],
         ["Sport","🎱⚾️⚽️🏀🏈🏓🥊⛷🏄🏻‍♂️🏊‍♂️🚴‍♀️🚣‍♀️🏋️‍♂️🪂🏹🏒"],
         ["Essen","🍎🍐🍉🍇🧅🥔🥨🍔🥗🥘🍱🥖🍗🥞🧇🥚"],
         ["Fahrzeuge","🚗🚌🚒🚜🛴🚲🛵🚠🚂✈️🚀🚁⛵️🚤🛶🚑"],
         ["Tiere","🐶🐹🐸🐔🐥🐝🦄🦋🦈🦧🐐🦜🐿🦔🦨🐘"],
         ["Gebäude","🏰🏟🏠🏭🏦💒🕌⛩⛺️⛲️🗽🗿🏯🎠🏪🏥"],
         ["Flaggen","🏴‍☠️🏳️‍🌈🇺🇳🇧🇪🇧🇷🇪🇺🇩🇪🇫🇷🇮🇱🇮🇹🇯🇵🇸🇪🇺🇸🇬🇧🇹🇷🇳🇴"]
       ]
    
    // return some random theme
    static func getRandomTheme() -> String {
        getTheme(index : themeList.count.arc4random)
    }
    // return specific theme
    static func getTheme(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind][1] : ""
    }
    // return specific theme name
    static func getThemeName(index ind : Int) -> String {
        ind < themeList.count ? themeList[ind][0] : ""
    }
}
// Int extension used for random number generatiom from 0..<self
extension Int {
    var arc4random : Int {
        get {
            return (self > 0 ?
                        Int(arc4random_uniform(UInt32(self))) :
                        (self < 0 ?
                            -Int(arc4random_uniform(UInt32(abs(self)))) :
                            0))
        }
    }
}
