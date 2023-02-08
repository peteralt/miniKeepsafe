//
//  ContentView.swift
//  MiniKeepsafe
//
//  Created by Peter Alt on 2/8/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GridViewFeature_View(
            store: .init(
                initialState: .sample,
                reducer: GridViewFeature()
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
