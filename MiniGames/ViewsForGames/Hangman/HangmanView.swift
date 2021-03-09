//
//  HangmanView.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import SwiftUI

struct HangmanView: View {
    @ObservedObject var gameStatus = HangmanGameStatus()
    
    
    var headerView : some View {
        HStack {
            Spacer()
            Button(action: {
                gameStatus.theWord = nil
            }){
               Image(systemName: "arrow.uturn.backward.circle.fill")
            }
        }
    }
    var body: some View {
        VStack {
            if let wordToDisplay = gameStatus.theWord {
                headerView
                Spacer()
                Text(wordToDisplay)
                Spacer()
            } else {
                HangmanPickerView(getWordFromSelected: gameStatus.getWordFromOption, isLoadingWord: gameStatus.isLoading)
            }
        }
    }
}

struct HangmanView_Previews: PreviewProvider {
    static var previews: some View {
        HangmanView()
    }
}
