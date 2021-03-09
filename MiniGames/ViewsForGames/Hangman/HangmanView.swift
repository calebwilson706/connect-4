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
                gameStatus.reset()
            }){
               Image(systemName: "arrow.uturn.backward.circle.fill")
            }.buttonStyle(HangmanResetButtonStyle())
        }.padding(.trailing,25)
    }
    var body: some View {
        VStack {
            if let wordToDisplay = gameStatus.theWord?.uppercased() {
                headerView
                Spacer()
                
                Group {
                    HStack(spacing : 20) {
                        ForEach(0..<wordToDisplay.count) { index in
                            let letter = wordToDisplay[index]
                            LetterView(letter: letter)
                        }
                    }.font(.largeTitle)
                    
                    AlphabetView(returnCharacter: self.gameStatus.addLetterToSelected)
                }.environmentObject(self.gameStatus)
                
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


struct LetterView : View {
    @EnvironmentObject var gameState : HangmanGameStatus
    let letter : Character
    
    var body : some View {
        if self.gameState.selectedLetters.contains(letter) || letter == " " {
            Text(String(letter))
        } else {
            Text("__")
        }
    }
}


struct AlphabetView : View {
    @EnvironmentObject var gameState : HangmanGameStatus
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    
    let returnCharacter : (Character) -> Void
    
    var body : some View {
        LazyVGrid(columns: layout, spacing : 20) {
            ForEach(65..<91){ ascii in
                let character = Character(UnicodeScalar(ascii)!)
                
                Button(action: {
                    returnCharacter(character)
                }){
                    Text(String(character)).font(.title)
                }.buttonStyle(HangmanSelectLetterButtonStyle(disabled : self.gameState.selectedLetters.contains(character)))
                
            }
        }.padding(.top)
    }
}
