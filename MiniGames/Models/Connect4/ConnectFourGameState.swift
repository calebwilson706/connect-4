//
//  ConnectFourGameState.swift
//  MiniGames
//
//  Created by Caleb Wilson on 08/03/2021.
//

import Foundation

class ConnectFourGameState : ObservableObject {
    @Published var scores : [ TheStatusOfCounter : Int ] = [
        .RED : 0,
        .BLUE : 0
    ]
    @Published var currentTeam : TheStatusOfCounter = .RED
}
