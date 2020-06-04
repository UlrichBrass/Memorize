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
    
    // add a presentation that displays the user profile in a modal view after tapping the profile icon in the tab bar.
    @State var showingProfile = false
    
    // Add a button to the navigation bar that toggles showProfile from false to true when tapped
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    var body: some View {
        // we use navigation views along with NavigationLink instances and related modifiers to build
        // hierarchical navigation structures in our app.
        NavigationView {
            // Display the themes using a List
            List {
                // Title line
                NavigationRow ( name : "Thema",  game : "Spiele", score : "Punkte     ")
                    .font(.headline)
                // Content lines
                ForEach(0..<viewModel.themes.themeCount) { themeIndex in
                    // pass theme information to the MemorizeView and the MemorizeViewModel.
                        NavigationLink(
                            // create a new  MemorizeView, to allow starting a new game each time
                            // execute destination only when clicked (lazy)
                            destination: NavigationLazyView(MemorizeView(themeNo : themeIndex))
                        ) {
                            NavigationRow ( name : self.viewModel.themes.getThemeName(index: themeIndex),
                                            game : String(self.viewModel.gameNo(themeNo : themeIndex)),
                                            score : String(self.viewModel.bestScore(themeNo : themeIndex)))

                        } // NavigationLink
                            .foregroundColor(Color(self.viewModel.themes.getThemeColorName(index: themeIndex)))
                } // ForEach
            } // List
            .navigationBarTitle(Text("Memory Themen"), displayMode: .inline)
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                ProfileHomeView()
                    .environmentObject(self.viewModel)
            }
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
// One line in our navigation list, can be title or content
struct NavigationRow : View{
    var name : String
    var game : String
    var score : String
    let frameWidth : CGFloat = 100
    
    var body: some View {
        HStack{
            Text(name)
                .frame(width: frameWidth )
            Spacer()
            Text(game)
                .frame(width: frameWidth )
            Spacer()
            Text(score)
                .frame(width: frameWidth )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(MemorizeViewModel())
    }
}
