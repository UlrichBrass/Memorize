//
//  GridView.swift
//  Memorize
//
//  Created by Ulrich Braß on 27.05.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// Create a grid view for Emojis
// This is the same as used for Memorize, however accepts 'id' keypath instead conforming to the Identifiable protocol
struct GridView<Item, ID, ItemView>: View where ID : Hashable, ItemView : View{
    private var items : [Item]
    private var viewForItems : (Item) -> ItemView
    private var id : KeyPath <Item ,ID >
   
    // We have that much space, and will find a layout to best fit all our items
    var body: some View {
        GeometryReader{ geometry in
            self.body(for : GridLayout(itemCount : self.items.count,  in : geometry.size))
        } // Geometry Reader
    } // body

    //We walk through all the items and create the  view for the item
    private func body(for layout : GridLayout) -> some View {
        ForEach(items, id : id) { item in
            self.body(for : item, in : layout)
        }// ForEach
    }
    
    // For a given item apply its view within it's grid frame and position
    private func body(for item : Item, in layout : GridLayout) -> some View {
        let index = items.firstIndex(where : {item[keyPath : id] == $0[keyPath : id]})!
        return viewForItems(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position (layout.location(ofItemAt: index))
    }
    
    init ( _ items : [Item], id : KeyPath <Item ,ID >, viewForItems : @escaping (Item) -> ItemView){
        self.items = items
        self.id = id
        self.viewForItems = viewForItems // function not called in init therefore @escaping
    }

} // GridView

// Now make GridView again compliant with the original version for Items conforming to Identifiable
extension GridView where Item : Identifiable, ID == Item.ID {
     init ( _ items : [Item], viewForItems : @escaping (Item) -> ItemView){
        self.init(items, id : \Item.id, viewForItems : viewForItems)
    }
}
