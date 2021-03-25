//
//  ContentView.swift
//  Connect-4
//
//  Created by Caleb Wilson on 24/02/2021.
//

import SwiftUI

enum ConnectFourPointsOptions : String, CaseIterable {
    case usePoints = "Use random score for each counter"
    case noPoints = "Don't use random points"
}



struct ConnectFourView: View {
    @ObservedObject private var gameState = ConnectFourGameState()
    @ObservedObject private var myGrid = ConnectFourGrid()
    @State private var showPopUp = false
    @State private var gameHasBeenEndedManually = false
    
    @State private var gameOption = ConnectFourPointsOptions.usePoints
    @State private var gameNotStarted = true
    
    var header : some View {
        HStack {
            Spacer()
            Button(action : {
                changeCurrentTeam()
            }){
                Text("Wrong Answer")
            }
            Text("Current Team : " + gameState.currentTeam.rawValue)
            Spacer()
            Button(action: {
                self.gameHasBeenEndedManually = true
                self.showPopUp = true
            }){
                Text("End Game And Get Scores")
            }
            Button(action : {
                resetGame()
            }){
                Text("Reset Game")
            }
            Spacer()
            
        }.padding()
    }
    
    var pickGameOptionView : some View {
        VStack {
            Picker("", selection: self.$gameOption) {
                ForEach(ConnectFourPointsOptions.allCases, id : \.self) { option in
                    Text(option.rawValue)
                }
            }
            Button(action : {
                gameNotStarted = false
            }) {
                Text("Continue")
            }
        }
    }
    var body: some View {
        VStack{
            if gameNotStarted {
                pickGameOptionView
            } else {
                header
                HStack {
                    ForEach(myGrid.grid, id: \.id){ stack in
                        VStack {
                            Button(action: {
                                addCounter(to: stack)
                            }){
                                Text(stack.id)
                            }.buttonStyle(ColumnHeaderButtonConnect4(disabled : stack.values[0].value != .EMPTY))
                            .disabled(stack.values[0].value != .EMPTY)
                            ForEach(stack.values, id :\.id){ counter in
                                CounterView(status: counter.value, number: counter.points, gameOption: gameOption)
                            }
                        }
                    }
                }.padding()
            }
        }.alert(isPresented: $showPopUp){
            let message = getMessageForEndOfGame()
            let title = getTitleForEndOfGame()
            
            return Alert(title: Text(title),
                  message: Text(message),
                  dismissButton: .default(Text("Reset Game")){
                    resetGame()
            })
        }
    }
    
    private func changeCurrentTeam() {
        gameState.currentTeam = (gameState.currentTeam == .BLUE) ? .RED : .BLUE
    }
    
    private func addCounter(to stack : ConnectFourStack){
        
        let placedAtPoint = placeCounterAndGetCoordinates(stack: stack)
        
        
        updateTotal(team: gameState.currentTeam, by: myGrid.grid[placedAtPoint.x].values[placedAtPoint.y].points )
        let completedItems =  myGrid.check(for: 4, starting: Point(x : placedAtPoint.x, y : placedAtPoint.y), previousDirection: .NONE)
        
        if let fourItemsInARow = completedItems {
            gameHasEnded(with: fourItemsInARow)
        } else {
            changeCurrentTeam()
        }
        
    }
    
    private func placeCounterAndGetCoordinates(stack : ConnectFourStack) -> Point {
        let x = myGrid.grid.firstIndex {$0.id == stack.id}!
        let stackToModify = myGrid.grid[x]
        let y = stackToModify.addCounter(colour : gameState.currentTeam)
        
        myGrid.grid[x] = stackToModify
        return Point(x: x, y: y)
    }
    
    private func gameHasEnded(with counters : [Point]) {
        myGrid.showFourInARow(path: counters)
        updateTotal(team: gameState.currentTeam, by: 200)
        self.showPopUp = true
    }
    
    private func updateTotal(team : TheStatusOfCounter, by amount : Int){
        gameState.scores[team]! += amount
    }
    
    private func resetGame() {
        myGrid.grid = ConnectFourGrid().grid
        self.gameState.scores[.RED] = 0
        self.gameState.scores[.BLUE] = 0
        self.gameState.currentTeam = .RED
        self.gameHasBeenEndedManually = false
        self.gameNotStarted = true
    }
    
    private func getTitleForEndOfGame() -> String {
        let congratulations = "Congratulations To The "
        
        if self.gameOption == .noPoints {
            return "The \(gameState.currentTeam.rawValue) Are The Winners!"
        }
        
        if let winner = getWinningTeam() {
            return congratulations + winner.rawValue + " Team!"
        } else if gameHasBeenEndedManually {
            return "It's A Tie!"
        } else {
            return congratulations + gameState.currentTeam.rawValue + " Team!"
        }
        
    }
    
    private func getMessageForEndOfGame() -> String {
        if self.gameOption == .noPoints {
            return "The \(gameState.currentTeam.rawValue) Got 4 In A Row!"
        }
        if getWinningTeam() != nil {
            return "The Red Team Scored \(gameState.scores[.RED]!) Points And The Blue Team Scored \(gameState.scores[.BLUE]!) Points!"
        } else {
            let equalPointsString = "Both teams scored equal points!"
            
            return equalPointsString + (gameHasBeenEndedManually ? "" : " However The \(gameState.currentTeam.rawValue) Team Got Four In A Row So They Win!")
        }
    }
    
    private func getWinningTeam() -> TheStatusOfCounter? {
        return (
            gameState.scores[.RED] == gameState.scores[.BLUE]
                ? nil : gameState.scores.max(by: { $0.value < $1.value })!.key
            
        )
    }
}

struct ContentFourView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectFourView()
    }
}


struct CounterView : View {
    var status : TheStatusOfCounter
    var number : Int
    var gameOption : ConnectFourPointsOptions
    
    var body: some View {
        ZStack {
            
            Circle()
            .fill(status == .EMPTY ? Color.gray : (status == .BLUE ? Color.blue : ( status == .RED ? Color.red : Color.yellow)))
            
            if status != .EMPTY && gameOption == .usePoints {
                Text("\(number)")
                    .bold()
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(status: .EMPTY, number: 10, gameOption: .usePoints)
    }
}
