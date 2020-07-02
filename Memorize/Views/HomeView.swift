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
    @EnvironmentObject var viewModel : MemorizeViewModel
    
    // control state of a presentation that displays the theme profile in a modal view after tapping the Theme name
    // in view NavigaionRow
    @State var showingThemeProfile = false
    @State var chosenThemeItem : Theme.ThemeItem = .defaultThemeItem
    //
    // Declare an edit mode state that is inactive by default.
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        // we use navigation views along with NavigationLink instances and related modifiers to build
        // hierarchical navigation structures in our app.
        NavigationView {
            // Display the themes using a List
            List {
                // Title line only shown in non edit mode
                if editMode == .inactive {
                    NavigationTitleRow ( name : "Thema",  currentScore:  "Punkte", bestScore : "Bestwert     ")
                        .font(.headline)
                }
                // Content lines
                ForEach(viewModel.themeList) { themeItem in
                    // pass theme information to the MemorizeView and the MemorizeViewModel.
                        NavigationLink(
                            // create a new  MemorizeView, to allow starting a new game each time
                            // execute destination view only when clicked (lazy)
                            destination: NavigationLazyView(MemorizeView(theme : themeItem))
                        ) {
                            NavigationRow ( themeProfileIsRequested  : self.$showingThemeProfile,
                                            chosenThemeItem : self.$chosenThemeItem,
                                            editMode : self.$editMode,
                                            themeItem : themeItem
                            )
                        } // NavigationLink
                            .foregroundColor(Color(themeItem.themeColor))
                } // ForEach
                // Edit Mode modifiers
                .onDelete(perform: deleteLines)
                .onMove(perform: moveLines)
                
            } // List
            // The following 2 buttons will control access to edit functions in HomeView
            .navigationBarTitle(barTitle, displayMode: .inline)
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            // Bind the editMode state to the DemoList view environment. This allows us to read and update the environment’s current editMode value.
            .environment(\.editMode, $editMode)
            // The following modifier will show a theme profile dialog for a chosen theme
            .sheet(isPresented: $showingThemeProfile) {
                ThemeEditorView(isShowing : self.$showingThemeProfile, themeItem : self.chosenThemeItem)
                    .environmentObject(self.viewModel)
            }
        } // NavidationView
    } // body
    //Add the system edit button that toggles the edit mode for the current scope.
    private var addButton: some View {
        switch editMode {
            case .inactive:
                return AnyView(EmptyView())
            default:
                return AnyView(Button(action: onAdd) { Image(systemName: "plus.square.on.square") })
        }
    }
    // have titles depend on mode
    private var barTitle: Text{
        switch editMode {
            case .inactive:
                return Text("Memory Themen")
            default:
                return Text("Themen anpassen")
        }
    }
    // Edit Mode functions on Theme List.
    func onAdd() {
        self.viewModel.addTheme()
    }
    // ...The right objects are picked, because ThemeItem conforms to Identifiable
    func deleteLines(offsets: IndexSet) {
        withAnimation {
            self.viewModel.deleteThemes(offsets: offsets)
        }
    }
    func moveLines(from: IndexSet, to: Int) {
        withAnimation {
            self.viewModel.moveThemes(from: from, to: to)
        }
    }
    //
    
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

// One content line in the navigation list. Update chosenThemeItem if selected by user
struct NavigationRow : View{
    @Binding var themeProfileIsRequested : Bool
    @Binding var chosenThemeItem : Theme.ThemeItem
    @Binding var editMode : EditMode
    var themeItem : Theme.ThemeItem
    let frameWidth : CGFloat = 100
    
    var body: some View {
        HStack{
            Text(themeItem.themeName)
                .frame(width: frameWidth )
            // theme editor only accessable in edit mode
            if editMode != .inactive {
                Image(systemName: "pencil")
                    // toggles showingProfile in parent view from false to true when tapped
                    .onTapGesture {
                            self.themeProfileIsRequested = true
                            self.chosenThemeItem = self.themeItem
                    }
                    .frame(width: frameWidth/2 )
            } else {
                Spacer()
                Text(String(themeItem.lastScore))
                    .frame(width: frameWidth )
                Spacer()
                Text(String(themeItem.bestScore))
                    .frame(width: frameWidth )
                }
        } //HStack
    }//body
} // View

// Title line of navigation list
struct NavigationTitleRow : View{
    var name : String
    var currentScore : String
    var bestScore : String
    let frameWidth : CGFloat = 100
    
    var body: some View {
        HStack{
            Text(name)
                .frame(width: frameWidth )
            Spacer()
            Text(currentScore)
                .frame(width: frameWidth )
            Spacer()
            Text(bestScore)
                .frame(width: frameWidth )
        }
    }
    
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(MemorizeViewModel())
    }
}
