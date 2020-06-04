//
//  ProfileSummaryView.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

struct ProfileSummaryView: View {
    var profile: Profile
    
    var body: some View {
        //displays the standard profile.
        List {
            Text(profile.profileName)
                .bold()
                .font(.title)
            
            Text("Anzahl Kartenpaare: \(self.profile.noOfPairsOfCards )")
            
            Text("Zeitlimit(sec): \(self.profile.bonusTimeLimit)")
            
        }
    }
}

struct ProfileSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummaryView(profile: Profile.default)
    }
}
