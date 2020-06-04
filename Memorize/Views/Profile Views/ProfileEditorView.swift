//
//  ProfileEditorView.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

struct ProfileEditorView: View {
    @Binding var profile: Profile
    
    var body: some View {
        List {
            HStack {
                Text("Profilname").bold()
                Divider()
                TextField("Profilname", text: $profile.profileName)
            }//HStack
            HStack {
                Text("Anzahl Kartenpaare:").bold()
                Divider()
                Stepper("\(profile.noOfPairsOfCards)", value: $profile.noOfPairsOfCards, in: 1...Profile.maxNoOfPairsOfCards)
            }//HStack
            HStack {
                Text("Zeitlimit(sec):").bold()
                Divider()
                Stepper("\(profile.bonusTimeLimit)", value: $profile.bonusTimeLimit, in: 1...Profile.maxBonusTimeLimit)
            }//HStack
        } // List
    }
}

struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView(profile: .constant(.default))
    }
}
