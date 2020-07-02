//
//  ProfileSummaryView.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

struct ProfileSummaryView: View {
    var themeItem : Theme.ThemeItem
    var body: some View {
        //displays the standard profile.
        List {
            Section {
                Text(self.themeItem.themeName)
                    .bold()
                    .font(.title)
            }
            Section(header : Text("Limits")){
                Text("Anzahl Kartenpaare: \(self.themeItem.noOfPairsOfCards )")
                Text("Zeitlimit(sec): \(self.themeItem.bonusTimeLimit)")
            }
            Section(header : Text("Eigenschaften")){
                HStack {
                    Text("Farbe: ")
                    Rectangle()
                        .fill(Color(self.themeItem.themeColor))
                        .frame(width: 40, height: 40)
                }
                VStack{
                    HStack{
                        Text("Emojis: ")
                        Spacer()
                }
                Text("\(self.themeItem.themeEmojis)")
                } //VStack
            }
        }
    } //body
} //View

struct ProfileSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummaryView( themeItem : .defaultThemeItem)
    }
}
