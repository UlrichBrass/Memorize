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
    @Environment(\.editMode) var mode
    @State var draftProfile = Profile.default
    
    var body: some View {
        //displays a stored profile, and allow changes
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.viewModel.profile
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton() //Toggle edit mode
            } // HStack
            if self.mode?.wrappedValue == .inactive {
                // show values in read mode
                ProfileSummaryView(profile: viewModel.profile)
            } else {
                // present values in edit mode
                ProfileEditorView(profile: $draftProfile)
                .onAppear {
                            self.draftProfile = self.viewModel.profile
                }
                .onDisappear {
                            self.viewModel.profile = self.draftProfile
                }
            }
        }
        .padding()
    }
}

struct ProfileHostView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHomeView().environmentObject(MemorizeViewModel())
    }
}
