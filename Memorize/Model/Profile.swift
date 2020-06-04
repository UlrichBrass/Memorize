//
//  Profile.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation

// User profile data read from and store in UserDefaults object
// The UserDefaults object is assigned per application, and can be used to store user preferences permanently
struct Profile {
    // Write to UserDefaults
    var profileName : String {
        didSet {
            UserDefaults.standard.set(profileName, forKey : Profile.keyProfileName)
        }
    }
    
    var bonusTimeLimit : Int {
        didSet {
            UserDefaults.standard.set(bonusTimeLimit, forKey : Profile.keyBonusTimeLimit)
        }
    }
    var noOfPairsOfCards : Int{
        didSet {
            UserDefaults.standard.set(noOfPairsOfCards, forKey : Profile.keyNoOfPairsOfCards)
        }
    }
    
    // Read defaults from UserDefaults object, or use constants for initial call
    static let keyProfileName = "Standard"
    static let keyBonusTimeLimit = "bonusTimeLimit"
    static let keyNoOfPairsOfCards = "noOfPairsOfCards"
    static let maxNoOfPairsOfCards = 16
    static let maxBonusTimeLimit =  14
    static let `default` = Self(profileName: UserDefaults.standard.string(forKey : Profile.keyProfileName) != nil ? UserDefaults.standard.string(forKey : Profile.keyProfileName)! : Profile.keyProfileName,
                                bonusTimeLimit : UserDefaults.standard.integer( forKey : Profile.keyBonusTimeLimit)  > 0 ? UserDefaults.standard.integer( forKey : Profile.keyBonusTimeLimit) :
                                    Profile.maxBonusTimeLimit/2,
                                noOfPairsOfCards : UserDefaults.standard.integer( forKey : Profile.keyNoOfPairsOfCards)  > 0 ? UserDefaults.standard.integer( forKey : Profile.keyNoOfPairsOfCards) : Profile.maxNoOfPairsOfCards)
    
    init(profileName: String, bonusTimeLimit: Int, noOfPairsOfCards : Int ) {
        self.profileName = profileName
        self.bonusTimeLimit = bonusTimeLimit
        self.noOfPairsOfCards = noOfPairsOfCards
    }
    
}
