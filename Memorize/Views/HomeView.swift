//
//  HomeView.swift
//  Memorize
//
//  Created by Ulrich Braß on 28.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI
// The home view not only contains all of the other views, it also provides
// the means of navigating through and displaying your app.
struct HomeView: View {
    
    var body: some View {
        // You use navigation views along with NavigationLink instances and related modifiers to build
        // hierarchical navigation structures in your app.
        NavigationView {
            // Display the themes using a List
            List {
                ForEach(0..<Theme.themeList.count) { themeIndex in
                    // pass theme information to the MemorizeView and the MemorizeViewModel.
                    NavigationLink(
                        // create a new  MemorizeView, to allow starting a new game each time
                        destination: MemorizeView(themeNo : themeIndex)
                    ) {
                        Text(Theme.getThemeName(index: themeIndex))
                    }
                    .foregroundColor(Theme.getThemeColor(index: themeIndex))
                }
                
            } // List
            .navigationBarTitle(Text("Memory Themen"), displayMode: .inline)
        } // NavidationView
    } // body
} // HomeView

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
