//
//  HangmanView.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import SwiftUI

struct HangmanView: View {
    @ObservedObject var gameStatus = HangmanGameStatus()
    
    @State var isGameOver = false
    @State var hasWonGame = false
    
    var headerView : some View {
        HStack {
            Spacer()
            Button(action: {
                resetGame()
            }){
               Image(systemName: "arrow.uturn.backward.circle.fill")
            }.buttonStyle(HangmanResetButtonStyle())
        }.padding(.trailing,25)
    }
    
    var hangmanImage : some View {
        Image("h-man-image-\(gameStatus.currentStage)")
            .resizable()
            .scaledToFit()
            .frame(maxHeight : 300)
            .padding(.all)
    }
    
    
    var body: some View {
        VStack {
            if let wordToDisplay = gameStatus.theWord?.uppercased() {
                headerView
                Spacer()
                hangmanImage
                Group {
                    HStack(spacing : 20) {
                        ForEach(0..<wordToDisplay.count) { index in
                            let letter = wordToDisplay[index]
                            LetterView(letter: letter)
                        }
                    }.font(.largeTitle)
                    
                    AlphabetView(returnCharacter: self.gameStatus.addLetterToSelected, checkIsGameOver: self.checkIsGameOver)
                }.environmentObject(self.gameStatus)
                
                Spacer()
                
            } else {
                HangmanPickerView(getWordFromSelected: gameStatus.getWordFromOption, isLoadingWord: gameStatus.isLoading)
            }
        }.alert(isPresented: $isGameOver){
            Alert(title: Text( hasWonGame ? "Yay!" : "Oh Nooo!"),
                  message: Text("You \(hasWonGame ? "Won" : "Lost") : The Word Was \(self.gameStatus.theWord!.capitalized)"),
                  dismissButton: .default(Text("Reset Game")) {
                    resetGame()
                  }
            )
        }
    }
    
    func checkIsGameOver() {
        if !self.gameStatus.theWord!.filter({ $0.isLetter }).uppercased().contains(where: { !self.gameStatus.selectedLetters.contains($0) }) {
            self.hasWonGame = true
            self.isGameOver = true
        } else if self.gameStatus.currentStage >= 9 {
            self.isGameOver = true
        }
    }
    
    func resetGame() {
        self.hasWonGame = false
        self.isGameOver = false
        gameStatus.reset()
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
    let checkIsGameOver : () -> Void
    
    var body : some View {
        LazyVGrid(columns: layout, spacing : 20) {
            ForEach(65..<91){ ascii in
                let character = Character(UnicodeScalar(ascii)!)
                let shouldDisable = self.gameState.selectedLetters.contains(character)
                    
                Button(action: {
                    returnCharacter(character)
                    checkIsGameOver()
                }){
                    Text(String(character)).font(.title)
                }.buttonStyle(HangmanSelectLetterButtonStyle(disabled : shouldDisable))
                .disabled(shouldDisable)
            }
        }.padding(.top)
    }
    
}
