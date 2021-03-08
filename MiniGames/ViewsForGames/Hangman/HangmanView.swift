//
//  HangmanView.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import SwiftUI

struct HangmanView: View {
    @ObservedObject var gameStatus = HangmanGameStatus()
    
    var body: some View {
        VStack {
            if let wordToDisplay = gameStatus.theWord {
                Text(wordToDisplay)
            } else {
                HangmanPickerView(getWordFromSelected: gameStatus.getWordFromOption)
            }
        }
    }
}

struct HangmanView_Previews: PreviewProvider {
    static var previews: some View {
        HangmanView()
    }
}
