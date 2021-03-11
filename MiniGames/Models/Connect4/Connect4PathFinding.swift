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
    func check(for amount : Int,
               starting : Point, previousDirection : Directions,
               currentPath : [Point] = []
    ) -> [Point]? {
        
        var working = currentPath
        working.append(starting)
        
        if amount == 1 {
            return working
        }
        
        let valueToSearchFor = grid[starting.x].values[starting.y].value
        
        if previousDirection != .NONE {
            let nextPoint = starting.move(direction: previousDirection)
            
            if checkIfValueIsEqual(valueToSearchFor, point: nextPoint) {
                return check(for: amount - 1, starting: nextPoint, previousDirection: previousDirection, currentPath: working)
            } else {
                return working
            }
            
        } else {
            var allPaths : [Directions : [Point]] = [:]
            var allDirections = Directions.allCases
            allDirections.removeAll { $0 == .NONE}
           
            for item in  allDirections{
                allPaths[item] = check(for: 4, starting: starting, previousDirection: item)
                
                if allPaths[item]?.count == 4 {
                    return allPaths[item]!
                }
            }
            
            if let path = checkDirectionsCombineForFull(.DOWNLEFT, .UPRIGHT, allPaths) {
                return path
            } else if let path = checkDirectionsCombineForFull(.LEFT, .RIGHT, allPaths) {
                return path
            } else if let path = checkDirectionsCombineForFull(.UPLEFT, .DOWNRIGHT, allPaths) {
                return path
            } else {
                return nil
            }
            
        }
        
    }

    
    func showFourInARow(path : [Point]){
        for item in path {
            grid[item.x].values[item.y].value = .COMPLETE_FOUR
        }
    }
    
    private func checkDirectionsCombineForFull(_ direct1 : Directions,
                                               _ direct2 : Directions,
                                               _ allPaths : [Directions : [Point]]
    ) -> [Point]? {
        let countOfBothPaths = (allPaths[direct1]?.count ?? 0) + (allPaths[direct2]?.count ?? 0)
        if (countOfBothPaths) >= 5 {
            let combo = allPaths[direct1]! + allPaths[direct2]!
            return (countOfBothPaths == 5) ? combo : combo.dropLast()
        }
        return nil
    }
    
    private func checkIfValueIsEqual(_ valueToSearch : TheStatusOfCounter,
                                     point : Point
                                     ) -> Bool {
        if (point.x > 6) || (point.x < 0) || (point.y < 0) || (point.y > 5){
            return false
        } else {
            return grid[point.x].values[point.y].value == valueToSearch
        }
    }
    
}
