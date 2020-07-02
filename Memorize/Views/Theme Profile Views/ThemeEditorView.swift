//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

struct ThemeEditorView: View {
    @EnvironmentObject var viewModel : MemorizeViewModel
    @Binding var isShowing : Bool
    @State var themeItem : Theme.ThemeItem
    
    @State var emojisToAdd : String  = ""
    @State var maxNoOfPairsOfCards = Theme.ThemeItem.maxNoOfPairsOfCards
    @State var uiColor : UIColor = UIColor.clear
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Spacer()
            // Conrol section for storing and cancelling changes
            HStack {
                // Camcel edit mode
                Spacer(minLength: 5)
                Button("Cancel") {
                        self.isShowing = false
                }
                Spacer(minLength: 60)
                Text("Themeneditor").bold()
                Spacer(minLength: 60)
                // Leave the edit mod, and store the changes
                Button("Done") {
                    self.themeItem.themeUIColor = self.uiColor
                    self.viewModel.storeThemeItem(theme : self.themeItem)
                    self.isShowing = false
                }
                Spacer(minLength: 5)
            } // HStack
            // The change form
            Form{
              // Change to theme name
                HStack {
                    Text("Themenname: ").bold()
                    Divider()
                    TextField("Themenname", text: $themeItem.themeName)
                }//HStack
                // Theme color management
                HStack {
                    Text("Farbe: ").bold()
                    Divider()
                    HStack{
                        Spacer()
                        ThemeColorView(uiColor: $uiColor)
                        Spacer()
                    }
                }
                // Define game playing parameters
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
                // Adding and deletion of Emojis
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
                    // Emoji deletion
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
        }
    } // Body
} // View

struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView(isShowing: Binding.constant(true), themeItem: .defaultThemeItem)
    }
}
