//
//  ProfileEditorView.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

struct ProfileEditorView: View {
    @Binding var themeItem : Theme.ThemeItem
    @State var emojisToAdd : String  = ""
    @State var maxNoOfPairsOfCards = Theme.ThemeItem.maxNoOfPairsOfCards
    @State var uiColor : UIColor = UIColor.clear
    var body: some View {
        Form{
            Section(header : Text("Themeneditor")){
                HStack {
                    Text("Themenname: ").bold()
                    Divider()
                    TextField("Themenname", text: $themeItem.themeName)
                }//HStack
                HStack {
                    Text("Farbe: ").bold()
                    Divider()
                    ThemeColorView(uiColor: $uiColor)
                }
            }
            Section(header : Text("Limits")){
                HStack {
                    Text("Anzahl Kartenpaare:").bold()
                    Divider()
                    Stepper("\(themeItem.noOfPairsOfCards)", value: $themeItem.noOfPairsOfCards, in: 1...self.maxNoOfPairsOfCards)
                }//HStack
                HStack {
                    Text("Zeitlimit(sec):").bold()
                    Divider()
                    Stepper("\(themeItem.bonusTimeLimit)", value: $themeItem.bonusTimeLimit, in: 1...Theme.ThemeItem.maxBonusTimeLimit)
                }//HStack
            }// Section
            Section (header : Text("Emojis")){
                // Emoji adding
                TextField("Emojis hinzufügen", text : $emojisToAdd, onEditingChanged : { began in
                        // we want to add emojis  only if editing ended (== !began)
                    if !began {
                        // here we have  a couple of new emojis ...
                        self.themeItem.themeEmojis = self.themeItem.themeEmojis + self.emojisToAdd
                        // ...and we want to make sure we increase the ones to be played accordingly
                        self.maxNoOfPairsOfCards = self.maxNoOfPairsOfCards + self.emojisToAdd.count
                        self.themeItem.noOfPairsOfCards = self.themeItem.noOfPairsOfCards + self.emojisToAdd.count
                        
                        self.emojisToAdd = ""
                        }
                    }
                    )
                VStack {
                    HStack{
                        Text("Emojis löschen").bold()
                        Spacer()
                    }
                    GridView(themeItem.themeEmojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                         .font(Font.system(size : 40))
                         .onTapGesture {
                            // remove Emojis, tapped on ...
                            self.themeItem.themeEmojis = self.themeItem.themeEmojis.replacingOccurrences(of: emoji, with: "")
                            if self.themeItem.themeEmojis.count == 0 {
                                //... however, must not empty emoji list
                                self.themeItem.themeEmojis = Theme.ThemeItem.noEmojis
                            }
                            // reduce the number of cards to be played to a maximumum of the ones remaiining
                            self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.themeEmojis.count)
                            if self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards{
                                self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
                            }
                     }
                 } // GridView
                    .frame(width : 300, height : 200 )
                }
            } // Section
        } // Form
        .onAppear{
            self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.themeEmojis.count)
            if self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards{
                self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
            }
            self.uiColor = self.themeItem.themeUIColor
        }
        .onDisappear{
            self.themeItem.themeUIColor = self.uiColor
            print("ProfileEditorView: \(self.themeItem.themeColor)")
        }
        
    } // Body
} // View

struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView(themeItem: .constant(.defaultThemeItem))
    }
}
