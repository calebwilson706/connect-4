//
//  Grid.swift
//  Connect-4
//
//  Created by Caleb Wilson on 24/02/2021.
//

import Foundation

let possiblePoints = [10, 10, 10, 10, 10, 20, 20, 20, 20, 25, 50, 100, 100, 100, 125]

class ConnectFourStack : ObservableObject {
    @Published var values = [Counter(),Counter(),Counter(),Counter(),Counter(),Counter()]
    @Published var id : String
    
    init(char : String){
        id = char
    }
    
    func addCounter(colour : TheStatusOfCounter) -> Int? {
        
        if values[0].value != .EMPTY {
            return nil
        }
        
        var index = values.count - 1
        print(index)
        
        while values[index].value != .EMPTY {
            index -= 1
        }
        
        values[index].value = colour
        return index
    }
}

enum TheStatusOfCounter : String {
    case BLUE = "Blue",
         RED = "Red",
         EMPTY = "None",
         COMPLETE_FOUR = "Done"
}
class Counter : ObservableObject {
    @Published var value = TheStatusOfCounter.EMPTY
    @Published var id = UUID()
    @Published var points : Int
    
    init() {
        points = possiblePoints.randomElement()!
    }
}

struct Point {
    var x : Int
    var y : Int
    
    func down() -> Point {
        return Point(x: x, y: y + 1)
    }
    func left() -> Point {
        return Point(x: x - 1, y: y)
    }
    func right() -> Point {
        return Point(x: x + 1, y: y)
    }
    func upleft() -> Point {
        return Point(x: x - 1, y: y - 1)
    }
    func upright() -> Point {
        return Point(x: x + 1, y: y - 1)
    }
    func downleft() -> Point {
        return Point(x: x - 1, y: y + 1)
    }
    func downright() -> Point {
        return Point(x: x + 1, y: y + 1)
    }
}


class ConnectFourGrid : ObservableObject {
    @Published var grid = [ConnectFourStack(char : "A"),
                           ConnectFourStack(char : "B"),
                           ConnectFourStack(char : "C"),
                           ConnectFourStack(char : "D"),
                           ConnectFourStack(char : "E"),
                           ConnectFourStack(char : "F"),
                           ConnectFourStack(char : "G")]
    
    
    
}
