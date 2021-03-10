//
//  Connect4PathFinding.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import Foundation

enum Directions : CaseIterable {
    case DOWN, LEFT,RIGHT ,UPLEFT , UPRIGHT, DOWNLEFT, DOWNRIGHT, NONE
}

extension ConnectFourGrid {
    func check(for amount : Int, starting : Point, previousDirection : Directions, currentPath : [Point] = []) -> [Point]? {
        
        var working = currentPath
        working.append(starting)
        
        if amount == 1 {
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
            
            
            
            if let path = checkDirections(.DOWNLEFT, .UPRIGHT, allPaths) {
                return path
            }
            
            if let path = checkDirections(.LEFT, .RIGHT, allPaths) {
                return path
            }
            
            if let path = checkDirections(.UPLEFT, .DOWNRIGHT, allPaths) {
                return path
            }
            
            return nil
        }
        
    }
    
    func showFourInARow(path : [Point]){
        for item in path {
            grid[item.x].values[item.y].value = .COMPLETE_FOUR
        }
    }
    func checkDirections(_ direct1 : Directions, _ direct2 : Directions, _ allPaths : [Directions : [Point]]) -> [Point]? {
        if ((allPaths[direct1]?.count ?? 0) + (allPaths[direct2]?.count ?? 0)) == 5 {
            return allPaths[direct1]! + allPaths[direct2]!
        }
        return nil
    }
}
