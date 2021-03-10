//
//  ContentView.swift
//  Connect-4
//
//  Created by Caleb Wilson on 24/02/2021.
//

import SwiftUI

struct ConnectFourView: View {
    @ObservedObject var gameState = ConnectFourGameState()
    @ObservedObject var myGrid = ConnectFourGrid()
    @State var showPopUp = false
    
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
            Button(action : {
                resetGame()
            }){
                Text("Reset Game")
            }
            Spacer()
            
        }.padding()
    }
    var body: some View {
        VStack{
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
                            CounterView(status: counter.value, number: counter.points)
                        }
                    }
                }
            }.padding()
        }.alert(isPresented: $showPopUp){
            var message = ""
            var title = ""
            
            if gameState.scores[.RED] == gameState.scores[.BLUE] {
                title = "Congratulations To The \(gameState.currentTeam.rawValue) Team!"
                message = "Both Teams Scored \(gameState.scores[.RED]!) points however since \(gameState.currentTeam.rawValue) got four in a row they win."
            } else {
                title = "Congratulations To The \(gameState.scores[.RED]! > gameState.scores[.BLUE]! ? "Red" : "Blue") Team!"
                message = "\(gameState.currentTeam.rawValue) Have 4 In A Row, The Red Team Scored \(gameState.scores[.RED]!) points and the Blue team scored \(gameState.scores[.BLUE]!) points"
            }
            
            return Alert(title: Text(title),
                  message: Text(message),
                  dismissButton: .default(Text("Reset Game")){
                    resetGame()
            })
        }
    }
    
    func changeCurrentTeam() {
        gameState.currentTeam = (gameState.currentTeam == .BLUE) ? .RED : .BLUE
    }
    
    func addCounter(to stack : ConnectFourStack){
        let x = myGrid.grid.firstIndex {$0.id == stack.id}!
        let stackToModify = myGrid.grid[x]
        let y = stackToModify.addCounter(colour : gameState.currentTeam)
        
        
        
        myGrid.grid[x] = stackToModify
        
        if y != nil {
            updateTotal(team: gameState.currentTeam, by: myGrid.grid[x].values[y!].points )
            let completedItems =  myGrid.check(for: 4, starting: Point(x : x, y : y!), previousDirection: .NONE)
            
            if completedItems != nil {
                myGrid.showFourInARow(path: completedItems!)
                updateTotal(team: gameState.currentTeam, by: 200)
                self.showPopUp = true
            } else {
                changeCurrentTeam()
            }
        }
    }
    
    func updateTotal(team : TheStatusOfCounter, by amount : Int){
        gameState.scores[team]! += amount
    }
    
    func resetGame() {
        myGrid.grid = ConnectFourGrid().grid
        self.gameState.scores[.RED] = 0
        self.gameState.scores[.BLUE] = 0
        self.gameState.currentTeam = .RED
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
    var body: some View {
        ZStack {
            
            Circle()
            .fill(status == .EMPTY ? Color.gray : (status == .BLUE ? Color.blue : ( status == .RED ? Color.red : Color.yellow)))
            
            if status != .EMPTY {
                Text("\(number)")
                    .bold()
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(status: .EMPTY, number: 10)
    }
}
