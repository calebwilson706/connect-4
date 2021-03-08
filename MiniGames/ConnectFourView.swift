//
//  ContentView.swift
//  Connect-4
//
//  Created by Caleb Wilson on 24/02/2021.
//

import SwiftUI

struct ConnectFourView: View {
    @ObservedObject var myGrid = ConnectFourGrid()
    @State var currentTeam = TheStatusOfCounter.RED
    @State var showPopUp = false
    
    @State var scores : [ TheStatusOfCounter : Int ] = [
        .RED : 0,
        .BLUE : 0
    ]
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button(action : {
                    changeCurrentTeam()
                }){
                    Text("Wrong Answer")
                }
                Text("Current Team : " + currentTeam.rawValue)
                Spacer()
                Button(action : {
                    resetGame()
                }){
                    Text("Reset Game")
                }
                Spacer()
                
            }.padding()
            
            HStack {
                ForEach(myGrid.grid, id: \.id){ stack in
                    VStack {
                        Button(action: {
                            addCounter(to: stack)
                        }){
                            Text(stack.id)
                        }.buttonStyle(ColumnHeaderButton(disabled : stack.values[0].value != .EMPTY))
                        ForEach(stack.values, id :\.id){ counter in
                            CounterView(status: counter.value, number: counter.points)
                        }
                    }
                }
            }.padding()
        }.alert(isPresented: $showPopUp){
            var message = ""
            var title = ""
            
            if scores[.RED] == scores[.BLUE] {
                title = "Congratulations To The \(currentTeam.rawValue) Team!"
                message = "Both Teams Scored \(scores[.RED]!) points however since \(currentTeam.rawValue) got four in a row they win."
            } else {
                title = "Congratulations To The \(scores[.RED]! > scores[.BLUE]! ? "Red" : "Blue") Team!"
                message = "\(currentTeam.rawValue) Have 4 In A Row, The Red Team Scored \(scores[.RED]!) points and the Blue team scored \(scores[.BLUE]!) points"
            }
            
            return Alert(title: Text(title),
                  message: Text(message),
                  dismissButton: .default(Text("Reset Game")){
                    resetGame()
            })
        }
    }
    
    func changeCurrentTeam() {
        currentTeam = (currentTeam == .BLUE) ? .RED : .BLUE
    }
    
    func addCounter(to stack : ConnectFourStack){
        let x = myGrid.grid.firstIndex {$0.id == stack.id}!
        let stackToModify = myGrid.grid[x]
        let y = stackToModify.addCounter(colour : currentTeam)
        
        
        
        myGrid.grid[x] = stackToModify
        
        if y != nil {
            updateTotal(team: currentTeam, by: myGrid.grid[x].values[y!].points )
            let completedItems =  myGrid.check(for: 4, starting: Point(x : x, y : y!), previousDirection: .NONE)
            
            if completedItems != nil {
                myGrid.showFourInARow(path: completedItems!)
                updateTotal(team: currentTeam, by: 200)
                self.showPopUp = true
            } else {
                changeCurrentTeam()
            }
        }
    }
    
    func updateTotal(team : TheStatusOfCounter, by amount : Int){
        scores[team]! += amount
    }
    
    func resetGame() {
        myGrid.grid = ConnectFourGrid().grid
        self.scores[.RED] = 0
        self.scores[.BLUE] = 0
        self.currentTeam = .RED
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
