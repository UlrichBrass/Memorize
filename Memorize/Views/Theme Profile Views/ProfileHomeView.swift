//
//  ProfileHomeView.swift
//  Memorize
//
//  Created by Ulrich Braß on 04.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI
// The ProfileHost view will host both a static, summary view of profile
// information as well as an edit mode.
struct ProfileHomeView: View {
    @EnvironmentObject var viewModel : MemorizeViewModel
    // The mode indicating whether the user can edit the contents of the view associated with this environment.
    @Environment(\.editMode) var mode
    @Binding var isShowing : Bool
    @State var chosenThemeItem : Theme.ThemeItem
    @State var draftThemeItem : Theme.ThemeItem = .defaultThemeItem
    
    var body: some View {
        //displays a stored profile, and allow changes
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    // Camcel edit mode
                    Button("Cancel") {
                        // we reset the draft profile, to make sure we show the right view in inactive mode
                        self.draftThemeItem = self.chosenThemeItem
                        self.mode?.wrappedValue = .inactive
                    }
                } else {
                    // Leave the read mode, same as swiping down
                    Button("Done") {
                        self.isShowing = false
                    }
                }
                Spacer()
                EditButton() //Toggle edit mode
            } // HStack
            if self.mode?.wrappedValue == .inactive {
                // show values in read mode
                ProfileSummaryView( themeItem : self.chosenThemeItem)
            } else {
                // present values in edit mode
                ProfileEditorView(themeItem : self.$draftThemeItem )
                .onAppear{
                    // prepare a draft profile, to allow reverting changes being made if cancelling the edit mode
                    self.draftThemeItem = self.chosenThemeItem
                }
                .onDisappear{
                    // TO DO: - THIS IS WRONG: "at this point we know, that edit mode was left with Done, and we need to store the changes in the draft profile"
                    // We only know, that edit mode ended, but in the cancel case we have restored draft from chosen, and as such restore chosen from chosen here
                    // TO DO: - ensure, that ProfileEditorView gets dismissed at this point, to ensure .onDisappear gets executed
                   
                    print("draft theme: \(self.draftThemeItem.themeColor)")
                   
                    self.chosenThemeItem = self.draftThemeItem
                    self.viewModel.storeThemeItem(theme : self.chosenThemeItem)
                }
            }
        }//VStack
        .padding()
    }
}

struct ProfileHostView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHomeView( isShowing: Binding.constant(true),
                         chosenThemeItem : .defaultThemeItem
                         )
            .environmentObject(MemorizeViewModel())
    }
}
