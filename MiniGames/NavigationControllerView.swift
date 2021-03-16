//
//  NavigationControllerView.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import SwiftUI

struct NavigationControllerView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink ("Connect Four", destination: ConnectFourView())
                NavigationLink("Hangman", destination: HangmanView())
            }
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar){
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
}

struct NavigationControllerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationControllerView()
    }
}

func toggleSidebar() {
    #if os(macOS)
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    #endif
}
