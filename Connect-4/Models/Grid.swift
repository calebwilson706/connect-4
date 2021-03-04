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

enum Directions : CaseIterable {
    case DOWN, LEFT,RIGHT ,UPLEFT , UPRIGHT, DOWNLEFT, DOWNRIGHT, NONE
}
class ConnectFourGrid : ObservableObject {
    @Published var grid = [ConnectFourStack(char : "A"),
                           ConnectFourStack(char : "B"),
                           ConnectFourStack(char : "C"),
                           ConnectFourStack(char : "D"),
                           ConnectFourStack(char : "E"),
                           ConnectFourStack(char : "F"),
                           ConnectFourStack(char : "G")]
    
    
    func check(for amount : Int, starting : Point, previousDirection : Directions, currentPath : [Point] = []) -> [Point]?{
        //print(starting)
        var working = currentPath
        working.append(starting)
        
        if amount == 1 {
            //print("found")
            return working
        }
        let stack = grid[starting.x].values
        let valueToSearchFor = stack[starting.y].value
        
        switch previousDirection {
        case .DOWN:
            if (starting.y != 5){
                if stack[starting.y + 1].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.down(), previousDirection: .DOWN,currentPath: working)
                } else {
                    return currentPath
                }
            } else {
                return currentPath
            }
        case .LEFT:
            if (starting.x != 0){
                if grid[starting.x - 1].values[starting.y].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.left(), previousDirection: .LEFT,currentPath: working)
                } else {
                    return working
                }
            } else {
                return working
            }
        case .RIGHT:
            if (starting.x != 6){
                if grid[starting.x + 1].values[starting.y].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.right(), previousDirection: .RIGHT, currentPath: working)
                } else {
                    return working
                }
            } else {
                return working
            }
        case .UPLEFT:
            if (starting.x != 0 && starting.y != 0){
                if grid[starting.x - 1].values[starting.y - 1].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.upleft(), previousDirection: .UPLEFT, currentPath: working)
                } else {
                    return working
                }
            } else {
                return working
            }
        case .UPRIGHT:
            if (starting.x != 6 && starting.y != 0){
                if grid[starting.x + 1].values[starting.y - 1].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.upright(), previousDirection: .UPRIGHT, currentPath: working)
                } else {
                    return working
                }
            } else {
                return working
            }
        case .DOWNLEFT:
            if (starting.x != 0 && starting.y != 5){
                if grid[starting.x - 1].values[starting.y + 1].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.downleft(), previousDirection: .DOWNLEFT,currentPath: working)
                } else {
                    return working
                }
            } else {
                return working
            }
        case .DOWNRIGHT:
            if (starting.x != 6 && starting.y != 5){
                if grid[starting.x + 1].values[starting.y + 1].value == valueToSearchFor {
                    return check(for: amount - 1, starting: starting.downright(), previousDirection: .DOWNRIGHT,currentPath: working)
                } else {
                    return working
                }
            } else {
                return working
            }
        case .NONE:
            var allPaths : [Directions : [Point]] = [:]
            
            for item in Directions.allCases {
                if item != .NONE {
                    allPaths[item] = check(for: 4, starting: starting, previousDirection: item)
                    
                    if allPaths[item]?.count == 4 {
                        return allPaths[item]!
                    }
                }
            }
            print(allPaths)
            if ((allPaths[.DOWNLEFT]?.count ?? 0) + (allPaths[.UPRIGHT]?.count ?? 0)) == 5 {
                return allPaths[.DOWNLEFT]! + allPaths[.UPRIGHT]!
            }
            
            if ((allPaths[.LEFT]?.count ?? 0) + (allPaths[.RIGHT]?.count ?? 0)) == 5 {
                return allPaths[.LEFT]! + allPaths[.RIGHT]!
            }
            
            if ((allPaths[.UPLEFT]?.count ?? 0) + (allPaths[.DOWNRIGHT]?.count ?? 0)) == 5 {
                return allPaths[.UPLEFT]! + allPaths[.DOWNRIGHT]!
            }
            
            return nil
        }
        
    }
    
    func showFourInARow(path : [Point]){
        for item in path {
            grid[item.x].values[item.y].value = .COMPLETE_FOUR
        }
    }
}
