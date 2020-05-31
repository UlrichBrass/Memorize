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
    //@ObservedObject var viewModel : MemorizeViewModel
    @EnvironmentObject var viewModel : MemorizeViewModel
    
    let frameWidth : CGFloat = 100
    
    var body: some View {
        // we use navigation views along with NavigationLink instances and related modifiers to build
        // hierarchical navigation structures in our app.
        NavigationView {
            // Display the themes using a List
            List {
                // Title line
                HStack{
                    Text("Thema")
                        .bold()
                        .frame(width: frameWidth )
                        
                    Spacer()
                    Text("Spiele")
                        .bold()
                        .frame(width: frameWidth )
                    Spacer()
                    Text("Punkte     ")
                        .bold()
                        .frame(width: frameWidth )
                }
                // Content lines
                ForEach(0..<Theme.themeList.count) { themeIndex in
                    // pass theme information to the MemorizeView and the MemorizeViewModel.
                        NavigationLink(
                            // create a new  MemorizeView, to allow starting a new game each time
                            // execute destination only when clicked (lazy)
                            destination: NavigationLazyView(MemorizeView(themeNo : themeIndex))
                        ) {
                            // get score and #games per theme from observed viewmodel object
                            Text(Theme.getThemeName(index: themeIndex))
                                .frame(width: self.frameWidth )
                            Spacer()
                            Text(String(self.viewModel.gameNo[themeIndex]))
                                .frame(width: self.frameWidth )
                            Spacer()
                            Text(String(self.viewModel.bestScore[themeIndex]))
                                .frame(width: self.frameWidth )
                        } // NavigationLink
                        .foregroundColor(Theme.getThemeColor(index: themeIndex))
                } // ForEach
            } // List
            .navigationBarTitle(Text("Memory Themen"), displayMode: .inline)
        } // NavidationView
    } // body
    
} // HomeView

// lazy navigation link, will only activate the view, when the link is actually clicked
// this is done by storing the view closure with @escaping parameter
struct NavigationLazyView<Content: View>: View {
    let follow: () -> Content
    init(_ follow:  @autoclosure @escaping () -> Content) {
        self.follow = follow
    }
    var body: Content {
        follow()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(MemorizeViewModel())
        //HomeView(viewModel : MemorizeViewModel())
    }
}
