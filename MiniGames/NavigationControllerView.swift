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
                NavigationLink(destination: ConnectFourView()) {
                    Text("Connect 4")
                }
                NavigationLink(destination: HangmanView()) {
                    Text("Hangman")
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
